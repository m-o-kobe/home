library(quantreg)
library(ggplot2)
#コマンドラインに樹種名、出力ファイル(csv),出力ファイル(画像)
tablecsv<-function(datalm,data,ou){
  N <- nrow(data)
  
  result <- cbind(datalm,N)
  ro<-nrow(result)
  co<-ncol(result)
  if(ro>1){
    result[2:nrow(result),co] <- ""
  }
  
  write.table(matrix(c("\n",colnames(result)),nrow=1),ou,append=T,quote=F,sep=",",row.names=F,col.names=F)
  write.table(result,ou,append=T,quote=F,sep=",",row.names=T,col.names=F)
}
args<-commandArgs(trailingOnly=T)
sp<-"lc"
motodata<-read.csv("nenrin.csv")
data<-subset(motodata,spp==sp)
gyou<-nrow(data)
data1<-data.frame()
for (i in 2:gyou){
  if (data$sikibetu[i]==data$sikibetu[i-1]){
    data2<-data[i,]
    data2$growth<-data$growth[i]-data$growth[i-1]
    data1<-rbind(data1, data2)
  }
}
data3<-subset(data1,data1$num!=806)
data4<-subset(data3,data3$age>10)




g <- ggplot(data4, aes(x = year, y = growth,color=sikibetu))
g <- g + geom_line()
plot(g)


data5<-summaryBy(.~num,data1)




taus <- c(.01,.05,.25,.50,.75,.95,.99)
buniten<-rq( (data$growth) ~ (data$dbh), tau=taus)
f<-coef(buniten)

kaiki001<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
                     growth=seq(min(data$dbh),max(data$dbh),10)*f[2,1]+f[1,1],
                     tau="0.01")

kaiki005<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
                     growth=seq(min(data$dbh),max(data$dbh),10)*f[2,2]+f[1,2],
                     tau="0.05")

kaiki025<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
                     growth=seq(min(data$dbh),max(data$dbh),10)*f[2,3]+f[1,3],
                     tau="0.25")

kaiki050<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
                     growth=seq(min(data$dbh),max(data$dbh),10)*f[2,4]+f[1,4],
                     tau="0.50")

kaiki075<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
                     growth=seq(min(data$dbh),max(data$dbh),10)*f[2,5]+f[1,5],
                     tau="0.75")
kaiki095<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
                     growth=seq(min(data$dbh),max(data$dbh),10)*f[2,6]+f[1,6],
                     tau="0.95")
kaiki099<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
                     growth=seq(min(data$dbh),max(data$dbh),10)*f[2,7]+f[1,7],
                     tau="0.99")

kaiki<-rbind(kaiki001,kaiki005,kaiki025,kaiki050,kaiki075,kaiki095,kaiki099)
g<-ggplot()+
  ggtitle(sp)+
  layer(
    data=data,
    mapping=aes(x=dbh,y=growth,alpha=0.01),
    geom="point",
    stat="identity",
    position="identity"
  )+
  layer(
    data=kaiki,
    mapping=aes(x=dbh,y=growth,colour=tau),
    geom="line",
    stat="identity",
    position="identity"
  )

tablecsv(f,data,outcsv)
png(outpic,height=960, width=960, res=144)
print(g)
dev.off()