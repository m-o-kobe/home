library(ggplot2)
#year=200
#year=500
year=1
i=6
#for (i in 1:10){
#filename=paste("output/pp3/output0127ctr_pp",i,".csv",sep="")
#filename="output/output0129ctr_heiwa.csv"
#filename="output/output0303.csv"

title1="2yr"
title1="200yr"




#colnames(dat)[2:3]<-c("V3","V2")
dat$sp<-as.factor(dat$sp)
output <-ggplot(dat, aes(V2, V3, size=V6, colour=sp))+
  geom_point(alpha=0.4)+
  coord_fixed(ratio=1)+
  labs(x="X", y="Y", title=paste(title1,"Year: ",year), size="DBH", colour="Species")+
  theme(plot.margin=unit(c(0,0,0,0),"lines"))+
  theme_bw()+
  scale_radius(name="DBH", breaks=seq(0,50,by=10),limits=c(0,50),range=c(0,15))+
  #scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
  scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
  scale_y_continuous(breaks=seq(0,100,by=10), limits=c(-2,102))+
  scale_colour_manual(values = c(Larix_cajanderi="#00BA38",Betula_platyphylla="#F8766D",Populus_tremula="#619CFF"))
print( output )

output <-ggplot(dat, aes(V2, V3, size=V6, colour=sp))+
  geom_point(alpha=0.4)+
  coord_fixed(ratio=1)+
  labs(x="X", y="Y", title=paste(title1,"Year: ",year), size="DBH", colour="Species")+
  theme(plot.margin=unit(c(0,0,0,0),"lines"))+
  theme_bw()+
  scale_radius(name="DBH", breaks=seq(0,50,by=10),limits=c(0,50),range=c(0,15))+
  #scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
  scale_x_continuous(breaks=seq(0,90,by=10), limits=c(-2,92))+
  scale_y_continuous(breaks=seq(0,100,by=10), limits=c(-2,102))+
  scale_colour_manual(values = c(Larix_cajanderi="#00BA38",Betula_platyphylla="#F8766D",Populus_tremula="#619CFF"))



print( output )
#}
#filename=paste("output/pp2/output0127ctr_pp",i,".csv",sep="")
g<-ggplot(data=dat,mapping=aes(x=V6,fill=sp))+
  scale_fill_manual(values = c(Larix_cajanderi="#00BA38",Betula_platyphylla="#F8766D",Populus_tremula="#619CFF"))+
  
  geom_histogram(binwidth = 5,position = "dodge")
#geom_histogram(position = "dodge")
label<-labs(title=paste(title1,"Year: ",year))#+xlim(0,30)
#    label<-labs(title="simulate_1year")
g<-g+label+ xlab("dbh(cm)")#+    ylim(0,30)

print(g)

type3<-dat
summary(type2)

type1lc<-subset(type1,type1$sp=="Larix_cajanderi")
summary(type1lc)
