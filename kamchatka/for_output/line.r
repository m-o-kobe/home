#args <- commandArgs(trailingOnly=T)
#filename <-args[1]
#outfile  <-args[2]
#title1<-args[3]
#filename <-"output/output.csv"
filename="output/output0129ctr_heiwa.csv"
title1<-"heiwa"
filename="output/output0129ctr_fire100.csv"
title1<-"fire100"
filename="output/output0129ctr_fire50.csv"
title1<-"fire50"

#outfile  <-"output/line0303.pdf"

library(ggplot2)
library(ggsci)

buf<-read.csv(filename,header=F)
#buf<-data
all_years<-sort(unique(buf$V1))

n<- 3
df <- data.frame(matrix(rep(NA, n), nrow=1))[numeric(0), ]
#pdf(outfile, paper ="a4", pointsize=18)

for (year in all_years){
    dat<-subset(buf,V1==year)
    for (j in 1:3){
        sp<-subset(dat,V4==j)
        spc<-sum(sp$V6>0)
         df<-rbind(df,c(j,year,spc))
    }
    

}
colnames(df) <- c("sp","year","num")
df$sp[df$sp==1]<-"Larix cajanderi"
df$sp[df$sp==2]<-"Betula platyphylla"
df$sp[df$sp==3]<-"Populus tremula"
chartmap<-ggplot(df,aes(x=year,y=num,color=sp))
charttype<-geom_line()

label<-labs(title=paste(title1))
axis<-scale_y_log10()
g<-chartmap+charttype+label#+axis
#print(df)
print(g)
#dev.off()
