DFb<-read.csv("ds4_brand_b.csv")
DFc<-read.csv("survey/ds4_brand_c.csv")
Db<-read.csv("df_c.csv",fileEncoding = "UTF-8")
DF2013<-subset(Db,Db$year>=2013)
DF2013_1<-subset(DF2013,DF2013$gyo2==1)
retu<-nrow(DF2013_1)
DF<-data.frame

DF<-cbind(DF2013_1[1,1:7],sqrt(DF2013_1[2,8:9]/DF2013_1[1,8:9]),DF2013_1[1,10:33])

for(i in 3:retu-1){
  if(DF2013_1$brand_id[i]==DF2013_1$brand_id[i+1]){
    a<-cbind(DF2013_1[i,1:7],sqrt(DF2013_1[i+1,8:9]/DF2013_1[i,8:9]),)
    DF<-rbind(DF,a)
  }
}

for(i in 3:retu-1){
  if(DF2013_1$brand_id[i]==DF2013_1$brand_id[i+1]){
    if(DF2013_1$year[i+1]-DF2013_1$year[i]!=1){
      print(DF2013_1$brand_id[i],DF2013_1$year[i])
    }
  }
}
#write.csv(DF,file="sabun_c.csv")

DF[is.na(DF)]<-1
DFforlm<-DF[9:33]
DF.lm<-lm(理解度~.,data=DFforlm)
DFstep<-step(DF.lm)