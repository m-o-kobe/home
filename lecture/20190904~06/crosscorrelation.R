prex<-27
prey<-28
DF <- read.csv("../../../marinair-pref.csv", header = TRUE, stringsAsFactors = FALSE)
xdata<-subset(DF,DF$Prefecturecode==prex)
ydata<-subset(DF,DF$Prefecturecode==prey)
x.ts<-as.ts(xdata$jinryu)
y.ts<-as.ts(ydata$jinryu)
print(x.ts)
print(y.ts)
#g<-ggplot(data=DF,aes(x=経過時間,y=人流指数,color=分類,group=都道府県))+
#scale_y_continuous(limits = c(0, 2000))+
#geom_line()
#geom_bar(stat="identity",position="fill")
png("../../../27_28.png",height=960, width=960, res=144)
ccf(x.ts,y.ts)

dev.off()
