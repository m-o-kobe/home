library(dplyr)
parent<-read.csv("5m_parent.csv", fileEncoding = "UTF-8-BOM")
children<-read.csv("5m_poplus_datateisei.csv",fileEncoding = "UTF-8-BOM")
children<-distinct(children)
sum1<-merge(parent,children,all=TRUE)
sum1[is.na(sum1)] <- 0

xmax<-16
ymax<-18

for(i in 1:xmax){
  xi<-i*5
  for(j in 1:ymax){
    yi<-j*5
    sum1[(sum1$x==xi)&(sum1$y==yi),c("Be_tonari","Po_tonari","La_tonari")]<-sum1[(sum1$x==xi-5)&(sum1$y==yi),c("Be","Po","La")]+
      sum1[(sum1$x==xi+5)&(sum1$y==yi),c("Be","Po","La")]+
      sum1[(sum1$x==xi)&(sum1$y==yi-5),c("Be","Po","La")]+
      sum1[(sum1$x==xi)&(sum1$y==yi+5),c("Be","Po","La")]
    sum1[(sum1$x==xi)&(sum1$y==yi),c("Be_naname","Po_naname","La_naname")]<-sum1[(sum1$x==xi-5)&(sum1$y==yi-5),c("Be","Po","La")]+
      sum1[(sum1$x==xi+5)&(sum1$y==yi-5),c("Be","Po","La")]+
      sum1[(sum1$x==xi+5)&(sum1$y==yi+5),c("Be","Po","La")]+
      sum1[(sum1$x==xi-5)&(sum1$y==yi+5),c("Be","Po","La")]
    
    }
}


sumBe<-sum1[,c("Be","Be_tonari","Be_naname","Be_sucker2000","Be_sucker2002","Be_seedling2000","Be_seedling2002")]

library(GGally)
Be<-ggpairs(sumBe)
print(Be)

sumPo<-sum1[,c("Po","Po_tonari","Po_naname","Po_sucker2000","Po_sucker2002","Po_sucker2004","Po_seedling2000","Po_seedling2002")]
Po<-ggpairs(sumPo)
print(Po)