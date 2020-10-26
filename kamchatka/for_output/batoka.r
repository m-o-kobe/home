#args <- commandArgs(trailingOnly=T)
#filename <-args[1]
#outfile  <-args[2]
#title1<-args[3]
filename<-"output/output1020_40yr.csv"
outfile<-"output/bar1020_40.pdf"
title1<-"fire"



library(ggplot2)
buf<-read.csv(filename,header=F)
all_years<-sort(unique(buf$V1))
max<-max(buf$V6)

width<-5
maxd<-1+max%/%width


n <- 3

pdf(outfile, paper ="a4", pointsize=18)
for (year in all_years){
#year<-40
  dat<-subset(buf,V1==year)
  dat<-subset(dat,dat$V6>0)
  colnames(dat)[4]<-"sp"
  dat$sp[dat$sp==1]<-"Larix cajanderi"
  dat$sp[dat$sp==2]<-"Betula platyphylla"
  dat$sp[dat$sp==3]<-"Populus tremula"
  g<-ggplot(data=dat,mapping=aes(x=V6,fill=sp))+
    geom_histogram(binwidth = 5,position = "dodge")
  label<-labs(title=paste(title1,"Year: ",year))
  #    label<-labs(title="simulate_1year")
  g<-g+label+ xlab("dbh(cm)")
  #+    ylim(0,30)
  
  print(g)
}
dev.off()


dat<-subset(buf,V1==year)
dat<-subset(dat,dat$V6<=0)

colnames(dat)[4]<-"sp"

summary(dat)

year=40
dat<-subset(buf,V1==year)
dat<-subset(dat,dat$V6>0)
dat$sp[dat$sp==1]<-"Larix cajanderi"
dat$sp[dat$sp==2]<-"Betula platyphylla"
dat$sp[dat$sp==3]<-"Populus tremula"

dat$sp<-as.factor(dat$sp)
g<-ggplot(data=dat,mapping=aes(x=V6))+
  geom_histogram(binwidth = 5,position = "dodge")+
  labs(title=paste(title1,":",year))+
  xlim(-5,30)+ylim(0,90)
  #scale_fill_manual(values = c("Larix cajanderi"="#00BA38","Betula platyphylla"="#F8766D","Populus tremula"="#619cFF"))
print(g)

dat$inch<-dat$V6/2.54


g<-ggplot(data=dat,mapping=aes(x=inch))+
  geom_histogram(binwidth = 1,position = "dodge")+
  labs(title=paste(title1,":",year))#+
#scale_fill_manual(values = c("Larix cajanderi"="#00BA38","Betula platyphylla"="#F8766D","Populus tremula"="#619cFF"))
print(g)

dat$ba<-2*asin(1)*dat$V6^2/4
sum(dat$ba)/(0.9*10000)
