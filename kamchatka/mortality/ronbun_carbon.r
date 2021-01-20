ronbun1<-read.csv("ronbun/carbon.csv",fileEncoding = "UTF-8-BOM")
library(ggplot2)
ronbun1$plot<-"mid"
ronbun1$plot[ronbun1$since_fire<15]<-"early"
ronbun1$plot[ronbun1$since_fire>100]<-"late"
g<-ggplot(data=ronbun1,aes(x=density,y=BA,colour=plot))+
  geom_point()
print(g)

ronbun2<-subset(ronbun1,ronbun1$trajectory==1)

g<-ggplot(data=ronbun2,aes(x=density,y=BA,colour=plot))+
  geom_point()
print(g)
