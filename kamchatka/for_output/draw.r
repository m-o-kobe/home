args <- commandArgs(trailingOnly=T)
filename <-args[1]
outfile  <-args[2]
title1<-args[3]
library(ggplot2)
pdf(outfile, paper ="a4", pointsize=18)

buf<-read.csv(filename, header=F)
all_years<-sort(unique(buf$V1))
sp<-c("Larix cajanderi", "Betula platyphylla", "Populus tremula")

for (year in all_years){
	dat<-subset(buf, V1==year)
	output <-ggplot(dat, aes(V2, V3, size=V6, colour=sp[V4]))+
	geom_point(alpha=0.4)+
	coord_fixed(ratio=1)+
	labs(x="X", y="Y", title=paste(title1,"Year: ",year), size="DBH", colour="Species")+
	theme(plot.margin=unit(c(0,0,0,0),"lines"))+
	theme_bw()+
	scale_radius(name="DBH", breaks=seq(0,50,by=10),limits=c(0,50),range=c(0,15))+
	scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
	scale_y_continuous(breaks=seq(0,100,by=10), limits=c(-2,102))+
	scale_colour_discrete(drop=FALSE)+
	scale_color_manual(values = c("Larix cajanderi"="#58BE89","Betula platyphylla"="#FBA848","Populus tremula"="#40AAEF"))

	print( output )
	#ggsave("output.pdf", plot=output, width=210, height=297, units= "mm")
}

dev.off()
