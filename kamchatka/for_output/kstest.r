motofire<-read.csv("fire_maiboku0212.csv")
df1<-motofire
subset(df1,is.na(df1$xx))

df1$xx<-as.numeric(df1$grid..x.)+as.numeric(as.character((df1$x)))
df1$yy<-as.numeric(df1$grid..y.)+as.numeric(as.character((df1$y)))
df2<-df1
df2$sp<-0
df2$sp[df2$sp.=="La"]<-1
df2$sp[df2$sp.=="Be"]<-2
df2$sp[df2$sp.=="Po"]<-3

sp="La"
sp2<-2
df3<-subset(df2,df2$D.A......2004.=="A")
df3<-subset(df2,df2$D.A..2000.=="A")

jitudata<-subset(df3,df3$sp.=="Be")

filename <-"output/output0303.csv"

buf<-read.csv(filename, header=F)
dat<-subset(buf,buf$V1==1)
dat1<-subset(dat,dat$V6>0)
dat2<-subset(dat1,dat1$V4==sp2)

ks.test(jitudata$dbh0,dat2$V6)
be2000jitu<-nrow(jitudata)
be2004jitu<-nrow(jitudata)
be2000simu<-nrow(dat2)
be2004simu<-nrow(dat2)

prop.test(c(be2004simu,be2004jitu),c(be2000simu,be2000jitu),correct = FALSE)


