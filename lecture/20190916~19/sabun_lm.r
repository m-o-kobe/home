library("matrixStats")


DFb<-read.csv("ds4_brand_b.csv")
DFc<-read.csv("survey/ds4_brand_c.csv")
Db<-read.csv("survey/df_b.csv",fileEncoding = "UTF-8")
DF2013<-subset(Db,Db$year>=2013)
DF2013_1<-subset(DF2013,DF2013$gyo2==1)
retu<-nrow(DF2013_1)
DF<-data.frame
DF2013_1<-DF2013_1[, colnames(DF2013_1) != "屋外広告.看板.電柱など."]
DF2013_1<-DF2013_1[, colnames(DF2013_1) != "職場の同僚.自社の購買担当者"]

DFmean<-colMeans(DF2013_1[10:31])
DFsd<-colSds(as.matrix(DF2013_1[10:31]))

DF<-cbind(DF2013_1[2,1:7],DF2013_1[2,8:9]-DF2013_1[1,8:9],(DF2013_1[2,10:31]-DFmean)/DFsd)
for(i in 3:retu-1){
  if(DF2013_1$brand_id[i]==DF2013_1$brand_id[i+1]){
    a<-cbind(DF2013_1[i+1,1:7],DF2013_1[i+1,8:9]-DF2013_1[i,8:9],(DF2013_1[i+1,10:31]-DFmean)/DFsd)
    DF<-rbind(DF,a)
    if(DF2013_1$year[i+1]-DF2013_1$year[i]!=1){
      print(DF2013_1$brand_id[i],DF2013_1$year[i])
    }
  }
}
#write.csv(DF,file="sabun_c.csv")

DFforlm<-DF[9:31]
DF.lm<-lm(理解度~.,data=DFforlm)
DFstep<-step(DF.lm)
DFforsei<-subset(DF,DF$year==2018)
DFforseibun<-DFforsei[c(10:31)]
p1<-prcomp(DFforseibun,scale=TRUE)
rownames(p1$x)<-DFforsei$shamei
biplot(p1)