csvdata<-read.csv("members/yuikosan2.csv", fileEncoding="UTF-8-BOM")
library(ggplot2)
zu<-ggplot(data=csvdata,aes(haba,dh))+
  geom_boxplot(aes(group=cut_width(haba,250)))
print(zu)

zu<-ggplot(data=csvdata,aes(x=haba,y=dh,colour=Height,fill=Height))+
  geom_boxplot(aes(group=cut_width(haba,250)))
print(zu)



zu<-ggplot(data=csvdata,aes(haba,dh))+
  #geom_violin(aes(group=cut_width(haba,200)))
#  geom_violin(aes(group=cut_width(haba,250)),trim=T,fill="#999999",linetype="blank",alpha=I(1/3))+
  stat_summary(geom="pointrange",
               fun.y = mean, 
               fun.ymin = function(x) mean(x)-sd(x),
               fun.ymax = function(x) mean(x)+sd(x), size=1,alpha=.5)+
  theme_bw()
print(zu)



zu<-ggplot(data=csvdata,aes(x=haba,y=dh,colour=Tree))+
  geom_point()+
  stat_summary(geom="pointrange",
               fun.data = "mean_cl_normal",
               size=1,)
print(zu)
kakunin<-as.factor(csvdata$haba)
levels(kakunin)
