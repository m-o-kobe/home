library(dplyr)
move<-read.csv("dataset-B/move-pref-all.csv", header = TRUE, stringsAsFactors = FALSE)
pop<-read.csv("dataset-B/population-pref.csv",header = FALSE, stringsAsFactors = FALSE)
move2010<-subset(move,move$year==2010)
pop2010<-as.data.frame(t(pop))
#head(pop2010,n=5)
names(pop2010)[1]<-"origin"
names(pop2010)[2]<-"ori2010"
pop2010<-select(pop2010,"origin","ori2010")
matome2010<-inner_join(pop2010,move2010,by="origin")
names(pop2010)[1]<-"destination"
names(pop2010)[2]<-"des2010"
matome2010<-inner_join(matome2010,pop2010,by="destination")

head(matome2010,n=5)




#head(pop2010)


#png(outpic,height=960, width=960, res=144)
#print(g)
#dev.off()