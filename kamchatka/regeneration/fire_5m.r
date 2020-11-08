library(dplyr)
parent<-read.csv("5m_parent.csv", fileEncoding = "UTF-8-BOM")
children<-read.csv("5m_poplus_datateisei.csv",fileEncoding = "UTF-8-BOM")
children<-distinct(children)
sum1<-merge(parent,children,all=TRUE)
sum1[is.na(sum1)] <- 0

sum(children$Po_sucker2000)+sum(children$Po_seedling2000)
sum(children$Be_sucker2000)+sum(children$Be_seedling2000)
sum(children$La_seedling2000)
sum(children$Po_sucker2004)


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

x<-0:19
x<-x*5-5
hanigai1<-data.frame(x=x,y=-5)
hanigai2<-data.frame(x=x,y=100)
y<-0:21
y<-y*5-5
hanigai3<-data.frame(x=-5,y=y)
hanigai4<-data.frame(x=90,y=y)
hanigai<-rbind(hanigai1,hanigai2,hanigai3,hanigai4)
hanigai$Po<-1
oya<-merge(hanigai,sum1,all=TRUE)
oya<-subset(oya,oya$Po>0)
#kodomo<-subset(sum1,sum1$Po_sucker2000>0)
kodomo<-subset(sum1,sum1$Po_sucker2000<1)

konum<-nrow(kodomo)
oyanum<-nrow(oya)
distlist<-list()
kodomo$dis<-0
for (i in 1:konum){
  dist_<-100
  for (j in 1:oyanum){
    dis<-((kodomo$x[i]-oya$x[j])^2+(kodomo$y[i]-oya$y[j])^2)^0.5
    if (dis<dist_){
      dist_<-dis
    }
    kodomo$dis[i]<-dist_
  }
}
kodomo1<-kodomo
kodomo1$sucker<-"t"
kodomo2<-kodomo
kodomo2$sucker<-"f"
kodomo3<-rbind(kodomo1,kodomo2)
p<-ggplot(kodomo3,aes(x=sucker,y=dis,colour=sucker,))+
  geom_violin()+geom_boxplot(width=.1,fill="black",outer.colour=NA)+
stat_summary(fun.y=mean,geom = "point", fill="white",shape=21,size=2.5)
print(p)



library(ggplot2)
g<-ggplot(data=sum1,mapping=aes(x=x,y=y,size=Po_sucker2000,colour=Po_sucker2000))+
  geom_point(alpha=0.3,fill="darkorange")+
  geom_text(mapping=aes(x=x,y=y,label=Po_sucker2000),size=5,colour="black")
print(g)
g<-ggplot(data=sum1,mapping=aes(x=x,y=y,size=Po))+
  geom_point(alpha=0.1,fill="darkorange")+
  geom_text(mapping=aes(x=x,y=y,label=Po))
print(g)


sumBe<-sum1[,c("Be","Be_tonari","Be_naname","Be_sucker2000","Be_sucker2002","Be_seedling2000","Be_seedling2002")]

library(GGally)
Be<-ggpairs(sumBe)
print(Be)

sumPo<-sum1[,c("Po","Po_tonari","Po_naname","Po_sucker2000","Po_sucker2002","Po_sucker2004","Po_seedling2000","Po_seedling2002")]
Po<-ggpairs(sumPo)
print(Po)