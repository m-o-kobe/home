#args <- commandArgs(trailingOnly=T)
#filename <-"output/output0118_intbp.csv"
#outfile  <-"output/draw0118.pdf"

title1<-"int_bp"
library(ggplot2)
pdf(outfile, paper ="a4", pointsize=18)

buf<-read.csv(filename, header=F)
all_years<-sort(unique(buf$V1))
#sp<-c("Larix cajanderi", "Betula platyphylla", "Populus tremula")
sp<-c("La", "Be", "pt")

#year<-10
year=160
year=1
for (year in all_years){
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
    scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
    scale_y_continuous(breaks=seq(0,100,by=10), limits=c(-2,102))#+

  
  print( output )
  #ggsave("output.pdf", plot=output, width=210, height=297, units= "mm")
}

dev.off()

df4$sp<-as.factor(df4$sp)

g<-ggplot(df4, aes(x, y, size=dbh, colour=sp))+
  #scale_color_manual(values = c("#FBA848","#58BE89","#40AAEF"))+
  labs(x="X", y="Y", title="40yr", size="DBH", colour="Species")+
  geom_point(alpha=0.4)+
  theme(plot.margin=unit(c(0,0,0,0),"lines"))+
  scale_size_continuous(range = c(1, 6))+
  theme_bw()+
  coord_fixed()+
  scale_radius(name="DBH", breaks=seq(0,50,by=10),limits=c(0,50),range=c(0,15))+
  #scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
  scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
  scale_y_continuous(breaks=seq(0,100,by=10), limits=c(-2,102))#+


print(g)
