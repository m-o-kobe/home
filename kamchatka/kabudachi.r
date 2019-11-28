DF<-read.csv("nenrin.csv",fileEncoding = "utf-8")
spDF<-subset(DF,DF$sprout>0)
columnList <- c("num", "spp", "dbh01", "hgt","sprout","age")
spDF<-spDF[,columnList]
countD<-as.data.frame(table(spDF$sprout))
colnames(countD)<-c("sprout","sproutnum")
spDF<-merge(spDF,countD)
spDF$agetrue<-is.na(spDF$age)
ggplot(spDF,aes(x=dbh01,y=age,colour=as.character(sprout)))+
  geom_point()
bpDF<-subset(DF,DF$spp=="bp")

hist(bpDF$dbh01)
s1<-subset(spDF,spDF$sproutnum==1)
s2<-subset(spDF,spDF$sproutnum>1)
hist(s1$dbh01)
hist(s2$dbh01)
spDF$sp_div<-(spDF$sproutnum+3)%/%5
g<-ggplot(spDF,aes(x=dbh01,fill=as.character(sp_div)))+
  geom_histogram(position="dodge")+
  scale_fill_npg()
print(g)
ageDF<-subset(spDF,spDF$age>0)
p<-ggplot(ageDF,aes(x=age,y=dbh01))+
  geom_point()
print(p)