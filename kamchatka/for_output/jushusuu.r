
filename <-"output/output_int0120_41to90ctr.csv"
outfile  <-"output/bar0405.pdf"
title1<-"heiwa"


library(ggplot2)

buf<-read.csv(filename,header=F)
all_years<-sort(unique(buf$V1))
max<-max(buf$V6)

width<-5
maxd<-1+max%/%width


n <- 3
year=100
  dat<-subset(buf,V1==year)
  dat<-subset(dat,dat$V6>0)
  colnames(dat)[4]<-"sp"
  
  dat$sp[dat$sp==1]<-"Larix cajanderi"
  dat$sp[dat$sp==2]<-"Betula platyphylla"
  dat$sp[dat$sp==3]<-"Populus tremula"
dat$sp<-as.factor(dat$sp)
summary(dat$sp)


