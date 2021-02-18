ctr1<-read.csv("ctrl0315.csv")
ctr2<-subset(ctr1,ctr1$dbh01>0.00001)
ctr21<-subset(ctr2,ctr2$spp=="lc")
ctr22<-subset(ctr2,ctr2$spp=="bp")

dat1<-subset(dat,dat$sp=="Larix_cajanderi")

ks.test(ctr21$dbh01,dat1$V6)

dat2<-subset(dat,dat$sp=="Betula_platyphylla")

ks.test(ctr22$dbh01,dat2$V6)


mean(ctr21$dbh01)
sd(ctr21$dbh01)


mean(ctr22$dbh01)
sd(ctr22$dbh01)
