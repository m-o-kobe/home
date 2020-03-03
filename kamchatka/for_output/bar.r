args <- commandArgs(trailingOnly=T)
filename <-args[1]
outfile  <-args[2]
title1<-args[3]
library(ggplot2)
buf<-read.csv(filename,header=F)
all_years<-sort(unique(buf$V1))
max<-max(buf$V6)

maxd<-1+max%/%5


n <- 3
pdf(outfile, paper ="a4", pointsize=18)

for (year in all_years){
df <- data.frame(matrix(rep(NA, n), nrow=1))[numeric(0), ]
    dat<-subset(buf,V1==year)
    for (j in 1:3){
        sp<-subset(dat,V4==j)
         for(i in 1:maxd){
            saidai=i*5
            saishou=saidai-5
            spc<-sum(sp$V6<=saidai)-sum(sp$V6<=saishou)

            df<-rbind(df,c(j,saidai,spc))
        }
    }

    colnames(df) <- c("sp","dbh","num")
    df$sp[df$sp==1]<-"Larix cajanderi"
    df$sp[df$sp==2]<-"Betula platyphylla"
    df$sp[df$sp==3]<-"Populus tremula"

    chartmap<-ggplot(df,aes(x=dbh,y=num,fill=sp))
    charttype<-geom_bar(stat="identity", position = "dodge")
    label<-labs(title=paste(title1,"Year: ",year))
    g<-chartmap+charttype+label
    print(g)
}