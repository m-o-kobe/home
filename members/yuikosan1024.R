csvdata<-read.csv("members/yuikosan2.csv", fileEncoding="UTF-8-BOM")
csvdata<-subset(csvdata,!is.na(csvdata$dh))
library(ggplot2)
zu<-ggplot(data=csvdata,aes(haba,dh))+
  geom_boxplot(aes(group=cut_width(haba,250)))
print(zu)

zu<-ggplot(data=csvdata,aes(x=haba,y=dh,colour=Height,fill=Height))+
  geom_boxplot(aes(group=cut_width(haba,250)))
print(zu)


#sd
zu<-ggplot(data=csvdata,aes(haba,dh))+
  #geom_violin(aes(group=cut_width(haba,200)))
#  geom_violin(aes(group=cut_width(haba,250)),trim=T,fill="#999999",linetype="blank",alpha=I(1/3))+
  stat_summary(geom="pointrange",
               fun.y = mean, 
               fun.ymin = function(x) mean(x)-sd(x),
               fun.ymax = function(x) mean(x)+sd(x), size=1,alpha=.5)+
  theme_bw()
print(zu)

zu<-ggplot(data=csvdata,aes(haba,dh))+
  #geom_violin(aes(group=cut_width(haba,200)))
  #  geom_violin(aes(group=cut_width(haba,250)),trim=T,fill="#999999",linetype="blank",alpha=I(1/3))+
  stat_summary(geom="crossbar",
               fun.y = mean, 
               fun.ymin = function(x) mean(x)-sd(x),
               fun.ymax = function(x) mean(x)+sd(x),
               fun.xmin = function(x) mean(x)-sd(x),
               fun.xmax = function(x) mean(x)+sd(x),
               
               size=1,alpha=.5)+
  theme_bw()
print(zu)

#四分位数
zu<-ggplot(data=csvdata,aes(x=haba,y=dh,colour=Tree))+
  #geom_violin(aes(group=cut_width(haba,200)))
  #  geom_violin(aes(group=cut_width(haba,250)),trim=T,fill="#999999",linetype="blank",alpha=I(1/3))+
  geom_point(alpha=0.3)+
  stat_summary(geom="pointrange",
               fun.y = function(x) quantile(x)[3], 
               fun.ymin = function(x) quantile(x)[2],
               fun.ymax = function(x) quantile(x)[4],
               width=0.5,
               size=1
               )+
  stat_summary(geom="pointrange",
               fun.y=mean,
               shape=4,
               size=1
               )+
  theme_bw()
print(zu)

zu<-ggplot(data=csvdata,aes(x=haba,y=dh,colour=Tree))+
  #geom_violin(aes(group=cut_width(haba,200)))
  #  geom_violin(aes(group=cut_width(haba,250)),trim=T,fill="#999999",linetype="blank",alpha=I(1/3))+
  geom_point(alpha=0.3,shape=1)+
  stat_summary(geom="pointrange",
               fun.y = function(x) quantile(x)[3], 
               fun.ymin = function(x) quantile(x)[2],
               fun.ymax = function(x) quantile(x)[4],
               size=1
  )+
  stat_summary(geom="pointrange",
               fun.y=mean,
               shape=4,
               size=1
  )+
  theme_bw()
print(zu)



#四分位数
zu<-ggplot(data=csvdata,aes(x=haba,y=dh,shape=Tree))+
  #geom_violin(aes(group=cut_width(haba,200)))
  #  geom_violin(aes(group=cut_width(haba,250)),trim=T,fill="#999999",linetype="blank",alpha=I(1/3))+
  geom_point(alpha=0.3,shape=1)+
  stat_summary(geom="pointrange",
               fun.y = function(x) quantile(x)[3], 
               fun.ymin = function(x) quantile(x)[2],
               fun.ymax = function(x) quantile(x)[4],
               width=0.5,
               size=1
  )+
  theme_bw()
print(zu)


quantile(csvdata$dh)[2]

zu<-ggplot(data=csvdata,aes(x=haba,y=dh,colour=Tree))+
  geom_point()+
  stat_summary(geom="pointrange",
               fun.data = "mean_cl_normal",
               size=1)
print(zu)
kakunin<-as.factor(csvdata$haba)
levels(kakunin)
