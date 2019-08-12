#コマンドラインに樹種名、出力ファイル(csv),出力ファイル(画像)
tablecsv<-function(datalm,data,ou){
    sum<-summary(datalm)
    coe <- sum$coefficient
    N <- nrow(data)
    aic <- AIC(datalm)
    result <- cbind(coe,aic,N)
    ro<-nrow(result)
    if(ro>1){
        result[2:nrow(result),5:6] <- ""
    }
    
    write.table(matrix(c("\n",colnames(result)),nrow=1),ou,append=T,quote=F,sep=","
    ,row.names=F,col.names=F)
    write.table(result,ou,append=T,quote=F,sep=",",row.names=T,col.names=F)
}
args<-commandArgs(trailingOnly=T)
sp<-args[1]
out<-args[2]
motodata<-read.csv("nenrin.csv")


data<-subset(motodata,spp==sp)
taus <- c(.01,.25,.05, .75,.99)
buniten<-rq( (data$growth) ~ (data$dbh), tau=taus)
f<-coef(buniten)

kaiki001<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
growth=seq(min(data$dbh),max(data$dbh),10)*f[2,1]+f[1,1],
tau="0.01")

kaiki025<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
growth=seq(min(data$dbh),max(data$dbh),10)*f[2,2]+f[1,2],
tau="0.25")

kaiki050<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
growth=seq(min(data$dbh),max(data$dbh),10)*f[2,3]+f[1,3],
tau="0.50")

kaiki075<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
growth=seq(min(data$dbh),max(data$dbh),10)*f[2,4]+f[1,4],
tau="0.75")
kaiki099<-data.frame(dbh=seq(min(data$dbh),max(data$dbh),10),
growth=seq(min(data$dbh),max(data$dbh),10)*f[2,5]+f[1,5],
tau="0.99")
kaiki<-rbind(kaiki001,kaiki025,kaiki050,kaiki075,kaiki099)
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


tablecsv(buniten,motodata,out)