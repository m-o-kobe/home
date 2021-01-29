#args <- commandArgs(trailingOnly=T)
#filename <-args[1]
#outfile  <-args[2]
#title1<-args[3]

filename <-"output/output0127ctr_pp2.csv"
outfile  <-"output/bar0405.pdf"
title1<-"fire"
title1<-"heiwa"


library(ggplot2)
buf<-read.csv(filename,header=F)
all_years<-sort(unique(buf$V1))
max<-max(buf$V6)

width<-5
maxd<-1+max%/%width
colnames(buf)[4]<-"sp"
buf$sp[buf$sp==1]<-"Larix_cajanderi"
buf$sp[buf$sp==2]<-"Betula_platyphylla"
buf$sp[buf$sp==3]<-"Populus_tremula"
buf$sp<-as.factor(buf$sp)


n <- 3
#pdf(outfile, paper ="a4", pointsize=18)
year=200
#for (year in all_years){
  dat<-subset(buf,V1==year)
  dat<-subset(dat,dat$V6>0.0001)
  summary(dat)
  
  #colnames(dat)[4]<-"sp"
  #dat$sp[dat$sp==1]<-"Larix cajanderi"
  #dat$sp[dat$sp==2]<-"Betula platyphylla"
  #dat$sp[dat$sp==3]<-"Populus tremula"
  g<-ggplot(data=dat,mapping=aes(x=V6,fill=sp))+
    scale_fill_manual(values = c(Larix_cajanderi="#00BA38",Betula_platyphylla="#F8766D",Populus_tremula="#619CFF"))+
    
    geom_histogram(binwidth = 5,position = "dodge")
  #geom_histogram(position = "dodge")
  label<-labs(title=paste(title1,"Year: ",year))#+xlim(0,30)
  #    label<-labs(title="simulate_1year")
  g<-g+label+ xlab("dbh(cm)")#+    ylim(0,30)
  
  print(g)
#}
#dev.off()
  ggColorHue <- function(n, l=65) {
    hues <- seq(15, 375, length=n+1)
    hcl(h=hues, l=l, c=100)[1:n]
  }
  
  cols       <- ggColorHue(n=4)
  ggColorHue(n=3)
year=5
dat<-subset(buf,V1==year)
dat<-subset(dat,dat$V6<=0)
colnames(dat)[4]<-"sp"
dat$sp[dat$sp==1]<-"Larix cajanderi"
dat$sp[dat$sp==2]<-"Betula platyphylla"
dat$sp[dat$sp==3]<-"Populus tremula"
dat$sp<-as.factor(dat$sp)
summary(dat)


ctr<-read.csv("ctrl0315.csv")
ctr_g<-ggplot(data=ctr_bp,mapping=aes(x=dbh01,fill=spp))+
  geom_histogram(position="dodge")+
  labs(title="ctr_bp")+    xlim(0,30)
