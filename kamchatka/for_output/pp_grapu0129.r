library(ggplot2)
title1="40yr_plot"
#year=200
year=160

i=6
#for (i in 1:10){
  filename=paste("output/pp3/output0127ctr_pp",i,".csv",sep="")
  
  data<-read.csv(filename,header = FALSE)
  dat<-subset(data,data$V1==year)
  dat<-subset(dat,dat$V6>0.0001)
  colnames(dat)[4]<-"sp"
  dat$sp[dat$sp==1]<-"Larix_cajanderi"
  dat$sp[dat$sp==2]<-"Betula_platyphylla"
  dat$sp[dat$sp==3]<-"Populus_tremula"
  
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
