#実生用だよー
library(dplyr)
library(doBy)
parent<-read.csv("fire_5m_da.csv", fileEncoding = "UTF-8-BOM")
children<-read.csv("fire2004seedling.csv", fileEncoding = "UTF-8-BOM")
children$SP[children$SP=="Larix"]<-"La"
children$SP[children$SP=="Populus"]<-"Po"

children<-subset(children,children$SP=="Be")
sum_children<-summaryBy(Hcm04~x+y,data = children,FUN=c(mean,length))

#children<-distinct(children)
sum1<-merge(parent,sum_children,all=TRUE)

x<-0:17
x<-x*5
y<-0:19
y<-y*5
allplot<-merge(x,y)
sum1<-merge(sum1,allplot,all=TRUE)
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
sumLa<-sum1[,c("La_A","La_D","La_tonari_A","La_tonari_D","La_naname_A","La_naname_D","Hcm04.length")]


sumBe<-sum1[,c("Be_A","Be_D","Be_tonari_A","Be_tonari_D","Be_naname_A","Be_naname_D","Hcm04.length")]


library(GGally)
La<-ggpairs(sumLa)
print(La)
Be<-ggpairs(sumBe)
print(Be)

sumPo<-sum1[,c("Po_tonari_A","Po_naname_A","Po_tonari_D","Po_naname_D","Po_sucker2000","Po_sucker2002","Po_sucker2004","Po_seedling2000","Po_seedling2002")]
sumPo<-sum1[,c("Po","Po_tonari_D","Po_naname_D","Po_sucker2000","Po_sucker2002","Po_sucker2004","Po_seedling2000","Po_seedling2002")]

Po<-ggpairs(sumPo)
print(Po)