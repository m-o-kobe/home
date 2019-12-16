df1<-read.csv("fire_da_basho.csv", fileEncoding = "UTF-8-BOM")
df1<-read.csv("fire_da_basho10m.csv", fileEncoding = "UTF-8-BOM")


children<-read.csv("5m_poplus_datateisei.csv",fileEncoding = "UTF-8-BOM")
children<-distinct(children)
sum1<-merge(df1,children,all=TRUE)
#sum1<-df1

xmax<-16
ymax<-18

for(i in 1:xmax){
  xi<-i*5
  for(j in 1:ymax){
    yi<-j*5
    sum1[(sum1$x==xi)&(sum1$y==yi),"da_tonari"]<-(sum1[(sum1$x==xi-5)&(sum1$y==yi),"da"]+
      sum1[(sum1$x==xi+5)&(sum1$y==yi),"da"]+
      sum1[(sum1$x==xi)&(sum1$y==yi-5),"da"]+
      sum1[(sum1$x==xi)&(sum1$y==yi+5),"da"])/4
    sum1[(sum1$x==xi)&(sum1$y==yi),"da_naname"]<-(sum1[(sum1$x==xi-5)&(sum1$y==yi-5),"da"]+
      sum1[(sum1$x==xi+5)&(sum1$y==yi-5),"da"]+
      sum1[(sum1$x==xi+5)&(sum1$y==yi+5),"da"]+
      sum1[(sum1$x==xi-5)&(sum1$y==yi+5),"da"])/4
    
  }
}
da<-data.frame(da1=0,da2=0)
colnames(da)<-c("da1","da2")
for(i in 0:xmax){
  xi<-i*5
  for(j in 0:ymax){
    yi<-j*5
    if(!is.na(sum1[(sum1$x==xi)&(sum1$y==yi),"da"])&(!is.na(sum1[(sum1$x==xi)&(sum1$y==yi+5),"da"]))){
      da1<-c(sum1[(sum1$x==xi)&(sum1$y==yi),"da"],sum1[(sum1$x==xi)&(sum1$y==yi+5),"da"])
      da<-rbind(da,da1)
    }
    if(!is.na(sum1[(sum1$x==xi)&(sum1$y==yi),"da"])&(!is.na(sum1[(sum1$x==xi+5)&(sum1$y==yi),"da"]))){
      da1<-c(sum1[(sum1$x==xi)&(sum1$y==yi),"da"],sum1[(sum1$x==xi+5)&(sum1$y==yi),"da"])
      da<-rbind(da,da1)
    }
  }
}
da<-data.frame(da1=0,da2=0)
colnames(da)<-c("da1","da2")
for(i in 0:xmax){
  xi<-i*10
  for(j in 0:ymax){
    yi<-j*10
    if((length(sum1[(sum1$x==xi)&(sum1$y==yi),"da"])==1)&(length(sum1[(sum1$x==xi)&(sum1$y==yi+10),"da"])==1)){
      da1<-c(sum1[(sum1$x==xi)&(sum1$y==yi),"da"],sum1[(sum1$x==xi)&(sum1$y==yi+10),"da"])
      da<-rbind(da,da1)
    }
    if((length(sum1[(sum1$x==xi)&(sum1$y==yi),"da"])==1)&(length(sum1[(sum1$x==xi+10)&(sum1$y==yi),"da"])==1)){
      da1<-c(sum1[(sum1$x==xi)&(sum1$y==yi),"da"],sum1[(sum1$x==xi+10)&(sum1$y==yi),"da"])
      da<-rbind(da,da1)
    }
  }
}
da2<-da[c(-1),]

da1<-sum1[c("da","da_tonari","da_naname")]
library(GGally)
da3<-ggpairs(da2)
print(da3)