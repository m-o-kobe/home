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

motodatac<-read.csv("ctrl0315.csv")
motodatai<-read.csv("int0313.csv")
motodata<-rbind(motodatac,motodatai)
data<-subset(motodata,motodata$dbh04>0)
data<-subset(data,data$dbh01>0)
data<-subset(data,data$spp==sp)

data$growth<-(data$dbh04-data$dbh01)*10/3
data<-subset(data,data$X.num!=497)


g <- ggplot(data4, aes(x = year, y = growth,color=sikibetu))
g <- g + geom_line()
plot(g)


data5<-summaryBy(.~num,data1)




taus <- c(.01,.05,.25,.50,.75,.95,.99)
buniten<-rq( (data$growth) ~ (data$dbh01), tau=taus)
f<-coef(buniten)

kaiki001<-data.frame(dbh=seq(min(data$dbh01),max(data$dbh01),10),
                     growth=seq(min(data$dbh01),max(data$dbh01),10)*f[2,1]+f[1,1],
                     tau="0.01")

kaiki005<-data.frame(dbh=seq(min(data$dbh01),max(data$dbh01),10),
                     growth=seq(min(data$dbh01),max(data$dbh01),10)*f[2,2]+f[1,2],
                     tau="0.05")

kaiki025<-data.frame(dbh=seq(min(data$dbh01),max(data$dbh01),10),
                     growth=seq(min(data$dbh01),max(data$dbh01),10)*f[2,3]+f[1,3],
                     tau="0.25")

kaiki050<-data.frame(dbh=seq(min(data$dbh01),max(data$dbh01),10),
                     growth=seq(min(data$dbh01),max(data$dbh01),10)*f[2,4]+f[1,4],
                     tau="0.50")

kaiki075<-data.frame(dbh=seq(min(data$dbh01),max(data$dbh01),10),
                     growth=seq(min(data$dbh01),max(data$dbh01),10)*f[2,5]+f[1,5],
                     tau="0.75")
kaiki095<-data.frame(dbh=seq(min(data$dbh01),max(data$dbh01),10),
                     growth=seq(min(data$dbh01),max(data$dbh01),10)*f[2,6]+f[1,6],
                     tau="0.95")
kaiki099<-data.frame(dbh=seq(min(data$dbh01),max(data$dbh01),10),
                     growth=seq(min(data$dbh01),max(data$dbh01),10)*f[2,7]+f[1,7],
                     tau="0.99")

kaiki<-rbind(kaiki001,kaiki005,kaiki025,kaiki050,kaiki075,kaiki095,kaiki099)
g<-ggplot()+
  ggtitle(sp)+
  layer(
    data=data,
    mapping=aes(x=dbh01*10,y=growth,alpha=0.01),
    geom="point",
    stat="identity",
    position="identity"
  )+
  layer(
    data=kaiki,
    mapping=aes(x=dbh*10,y=growth,colour=tau),
    geom="line",
    stat="identity",
    position="identity"
  )
print(g)

tablecsv(f,data,outcsv)
png(outpic,height=960, width=960, res=144)
print(g)
dev.off()