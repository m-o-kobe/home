library(dplyr)
parent<-read.csv("fire_5m_da.csv", fileEncoding = "UTF-8-BOM")
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
    sum1[(sum1$x==xi)&(sum1$y==yi),c("Be_tonari_A","Po_tonari_A","La_tonari_A","Be_tonari_D","Po_tonari_D","La_tonari_D")]<-sum1[(sum1$x==xi-5)&(sum1$y==yi),c("Be_A","Po_A","La_A","Be_D","Po_D","La_D")]+
      sum1[(sum1$x==xi+5)&(sum1$y==yi),c("Be_A","Po_A","La_A","Be_D","Po_D","La_D")]+
      sum1[(sum1$x==xi)&(sum1$y==yi-5),c("Be_A","Po_A","La_A","Be_D","Po_D","La_D")]+
      sum1[(sum1$x==xi)&(sum1$y==yi+5),c("Be_A","Po_A","La_A","Be_D","Po_D","La_D")]
    sum1[(sum1$x==xi)&(sum1$y==yi),c("Be_naname_A","Po_naname_A","La_naname_A","Be_naname_D","Po_naname_D","La_naname_D")]<-sum1[(sum1$x==xi-5)&(sum1$y==yi-5),c("Be_A","Po_A","La_A","Be_D","Po_D","La_D")]+
      sum1[(sum1$x==xi+5)&(sum1$y==yi-5),c("Be_A","Po_A","La_A","Be_D","Po_D","La_D")]+
      sum1[(sum1$x==xi+5)&(sum1$y==yi+5),c("Be_A","Po_A","La_A","Be_D","Po_D","La_D")]+
      sum1[(sum1$x==xi-5)&(sum1$y==yi+5),c("Be_A","Po_A","La_A","Be_D","Po_D","La_D")]
    
  }
}


sumBe<-sum1[,c("Be","Be_tonari","Be_naname","Be_sucker2000","Be_sucker2002","Be_seedling2000","Be_seedling2002")]

library(GGally)
Be<-ggpairs(sumBe)
print(Be)

sumPo<-sum1[,c("Po_tonari_A","Po_naname_A","Po_tonari_D","Po_naname_D","Po_sucker2000","Po_sucker2002","Po_sucker2004","Po_seedling2000","Po_seedling2002")]
sumPo<-sum1[,c("Po","Po_tonari_D","Po_naname_D","Po_sucker2000","Po_sucker2002","Po_sucker2004","Po_seedling2000","Po_seedling2002")]

Po<-ggpairs(sumPo)
print(Po)