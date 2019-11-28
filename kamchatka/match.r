library(vegan)

motodata<-read.csv("match.csv",row.names=1)
data1<-vegdist(motodata,method="morisita")