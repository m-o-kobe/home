library(ggplot2)
library(doBy)
library(dplyr)
DF <- read.csv("../../../marinair-pref.csv", header = TRUE, stringsAsFactors = FALSE)
pop<- read.csv("../../../population.csv", header = TRUE, stringsAsFactors = FALSE)
pop$kinki<-0
pop$flight<-0
pop[24:30,]$kinki<-1

pop[pop$Prefecturecode==1,]$flight<-399777
pop[pop$Prefecturecode==4,]$flight<-154769
pop[pop$Prefecturecode==8,]$flight<-156537
pop[pop$Prefecturecode==13,]$flight<-849615
pop[pop$Prefecturecode==42,]$flight<-219194
pop[pop$Prefecturecode==46,]$flight<-151524
pop[pop$Prefecturecode==47,]$flight<-427342
jinryu<-summaryBy(jinryu~Prefecturecode,data=DF,FUN=(mean))
names(jinryu)[2]<-"jinryu"
matome<-inner_join(pop,jinryu)
matome

lmresult<-lm(jinryu~Population+kinki+flight,data=matome)
summary(lmresult)
#g<-ggplot(data=DF,aes(x=経過時間,y=人流指数,color=分類,group=都道府県))+
#scale_y_continuous(limits = c(0, 2000))+
#geom_line()
#geom_bar(stat="identity",position="fill")
#png("../../../rrenshu.png",height=960, width=960, res=144)
#print(g)
#dev.off()
