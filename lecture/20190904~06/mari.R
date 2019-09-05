library(ggplot2)
DF <- read.csv("../../../marinair-pref.csv", header = TRUE, stringsAsFactors = FALSE)

DFkansai<-subset(DF,(DF$都道府県コード<=30)&DF$都道府県コード>=24)
g<-ggplot(data=DFkansai,aes(x=経過時間,y=人流指数,color=都道府県))+
#geom_line()
geom_bar(stat="identity",position="fill")
png("../../../rrenshu.png",height=960, width=960, res=144)
print(g)
dev.off()
