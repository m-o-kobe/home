library(ggplot2)
args<-commandArgs(trailingOnly=T)
outpic<-args[1]
data<-read.csv("../nenrin.csv")
p<-ggplot(data=data,aes(x=dbh,y=age))+
geom_point(mapping=aes(colour=spp))+
coord_fixed()
png(outpic,height=960, width=960, res=144)
print(p)
dev.off()