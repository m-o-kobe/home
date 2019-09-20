DFb<-read.csv("df_c.csv",fileEncoding = "UTF-8")
retu<-nrow(DFb)

hokanDF<-data.frame
df<-subset(DFb,DFb$gyo2==0)
DFhokan1<-mice(df[10:24],method="mean",m=1,maxit=1)
DFhokan2<-mice(df[25:33],method="mean",m=1,maxit=1)
hokanDF<-cbind(df[1:9],complete(DFhokan1),complete(DFhokan2))

for(i in 1:17){
  df<-subset(DFb,DFb$gyo2==i)
  DFhokan1<-mice(df[10:24],method="mean",m=1,maxit=1)
  DFhokan2<-mice(df[25:33],method="mean",m=1,maxit=1)
  a<-cbind(df[1:9],complete(DFhokan1),complete(DFhokan2))
  hokanDF<-rbind(hokanDF,a)
}
hokanDF[!complete.cases(hokanDF),]
write.csv(hokanDF,file="hokan_c.csv")