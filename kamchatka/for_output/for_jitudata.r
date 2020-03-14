#args <- commandArgs(trailingOnly=T)
#filename <-args[1]
#outfile  <-args[2]
#title1<-args[3]
filename <-"setting/init_fire0302.csv"
title1<-"fire_2004"



library(ggplot2)
buf<-read.csv(filename,header=T)
dat<-subset(df3,df3$D.A..2000.=="A")
dat<-dat$subset(dat,dat$dbh0>0)
dat$sp[dat$sp==1]<-"Larix cajanderi"
dat$sp[dat$sp==2]<-"Betula platyphylla"
dat$sp[dat$sp==3]<-"Populus tremula"

  g<-ggplot(data=dat,mapping=aes(x=dbh0,fill=sp))+
    geom_histogram(binwidth = 5,position = "dodge")+
    labs(title=paste(title1))+
    scale_fill_manual(values = c("Larix cajanderi"="#00BA38","Betula platyphylla"="#F8766D","Populus tremula"="#619cFF"))
  print(g)

  df4<-subset(df3,df3$D.A......2004.=="A")
  
  df4$dbh04<-df4$GBH04/acos(-1)
  
  
  dat<-df4
  dat$sp[dat$sp==1]<-"Larix cajanderi"
  dat$sp[dat$sp==2]<-"Betula platyphylla"
  dat$sp[dat$sp==3]<-"Populus tremula"
  
  g<-ggplot(data=dat,mapping=aes(x=dbh04,fill=sp))+
    geom_histogram(binwidth = 5,position = "dodge")+
    labs(title=paste(title1))+
    scale_fill_manual(values = c("Larix cajanderi"="#00BA38","Betula platyphylla"="#F8766D","Populus tremula"="#619cFF"))+
    ylim(0,30)
  print(g)
  
