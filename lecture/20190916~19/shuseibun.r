DBb<-read.csv("survey/ds4_brand2018_b.csv")
DBc<-read.csv("survey/ds4_brand2018_c.csv")

DBcall<-subset(DBc,DBc$row=="全体")
DBcall1<-DBcall[,c(191:209)]
DBcp191_209<-prcomp(DBcall1,scale=TRUE)
rownames(DBcp191_209$x)<-DBcall$shamei
biplot(DBcp191_209)