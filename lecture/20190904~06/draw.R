library(ggplot2)
DF <- read.csv("../../../marinair-pref.csv", header = TRUE, stringsAsFactors = FALSE)

DF$分類<-"その他"
DF[1063:1211,]$分類<-"関西"
DF[DF$都道府県=="北海道",]$分類<-"飛行場"
DF[DF$都道府県=="茨城県",]$分類<-"飛行場"
DF[DF$都道府県=="東京都",]$分類<-"飛行場"
DF[DF$都道府県=="長崎県",]$分類<-"飛行場"
DF[DF$都道府県=="鹿児島県",]$分類<-"飛行場"
DF[DF$都道府県=="沖縄県",]$分類<-"飛行場"

g<-ggplot(data=DF,aes(x=経過時間,y=人流指数,color=分類,group=都道府県))+
scale_y_continuous(limits = c(0, 2000))+
geom_line()
#geom_bar(stat="identity",position="fill")
png("../../../rrenshu.png",height=960, width=960, res=144)
print(g)
dev.off()