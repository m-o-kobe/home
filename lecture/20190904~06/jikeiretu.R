DF <- read.csv("../../../marinair-pref.csv", header = TRUE, stringsAsFactors = FALSE)

DFkobe<-subset(DF,(DF$都道府県=="兵庫県"))
jikeiretu<-ts(DFkobe$人流指数)
print(jikeiretu)
png("../../../rrenshu.png",height=960, width=960, res=144)
plot(acf(jikeiretu,lag.max=24))
dev.off()