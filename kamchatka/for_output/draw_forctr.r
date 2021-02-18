#args <- commandArgs(trailingOnly=T)
#filename <-"output/output1020_40yr.csv"
#outfile  <-"output/draw1020_40yr.pdf"

#filename <-"output/output1218_1to50.csv"
#outfile  <-"output/draw1218_1to50yr.pdf"

#filename <-"output/output1218_41to90.csv"
#outfile  <-"output/draw1218_41to90yr.pdf"
filename<-"output/0125int_heiwa.csv"

title1<-"ctr_41to90"
library(ggplot2)
pdf(outfile, paper ="a4", pointsize=18)

buf<-read.csv(filename, header=F)
all_years<-sort(unique(buf$V1))
#sp<-c("Larix cajanderi", "Betula platyphylla", "Populus tremula")
sp<-c("La", "Be", "pt")
#year<-10

#for (year in all_years){
  dat<-subset(buf, V1==year)
  dat<-subset(dat,V6>0.0)
  output <-ggplot(dat, aes(V2, V3, size=V6, colour=sp[V4]))+
    geom_point(alpha=0.4)+
    coord_fixed(ratio=1)+
    labs(x="X", y="Y", title=paste(title1,"Year: ",year), size="DBH", colour="Species")+
    theme(plot.margin=unit(c(0,0,0,0),"lines"))+
    theme_bw()+
    scale_radius(name="DBH", breaks=seq(0,50,by=10),limits=c(0,50),range=c(0,15))+
    #scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
    scale_x_continuous(breaks=seq(0,100,by=10), limits=c(-2,102))+
    scale_y_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
    scale_colour_discrete(drop=FALSE)+
    #scale_color_manual(values = c("Larix cajanderi"="#58BE89","Betula platyphylla"="#FBA848","Populus tremula"="#40AAEF"))+
    scale_color_manual(values = c("La"="#58BE89","Be"="#FBA848","Po"="#40AAEF"))
  
  #	scale_size_continuous(range = c(1, 6))
  
  print( output )
  #ggsave("output.pdf", plot=output, width=210, height=297, units= "mm")
#}

dev.off()
