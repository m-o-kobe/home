#args <- commandArgs(trailingOnly=T)
#filename <-args[1]
#outfile  <-args[2]
#title1<-args[3]
filename <-"output/output1218_1to50.csv"
outfile  <-"output/bar1218_1to50yr.pdf"
title1<-"ctr_1to50"

filename <-"output/output1218_41to90.csv"
outfile  <-"output/bar1218_41to90yr.pdf"
title1<-"ctr_41to90"



library(ggplot2)
buf<-read.csv(filename,header=F)

all_years<-sort(unique(buf$V1))
max<-max(buf$V6)

width<-5
maxd<-1+max%/%width


n <- 3
pdf(outfile, paper ="a4", pointsize=18)
for (year in all_years){
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
  g<-g+label+ xlab("dbh(cm)")+    ylim(0,40)
  print(g)
}
dev.off()

year=5
dat<-subset(buf,V1==year)
dat<-subset(dat,dat$V6<=0)
colnames(dat)[4]<-"sp"
dat$sp[dat$sp==1]<-"Larix cajanderi"
dat$sp[dat$sp==2]<-"Betula platyphylla"
dat$sp[dat$sp==3]<-"Populus tremula"
dat$sp<-as.factor(dat$sp)
summary(dat)

