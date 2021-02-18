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

spp="Be"
sp2<-2
df3<-subset(df2,df2$D.A......2004.=="A")
df3<-subset(df2,df2$D.A..2000.=="A")

jitudata<-subset(df3,df3$sp.==spp)

filename <-"output/output0405.csv"

buf<-read.csv(filename, header=F)
dat<-subset(buf,buf$V1==1)
dat1<-subset(dat,dat$V6>0)
dat2<-subset(dat1,dat1$V4==sp2)

kt<-ks.test(jitudata$dbh0,dat2$V6)
kt

be2000jitu<-nrow(jitudata)
be2004jitu<-nrow(jitudata)
be2000simu<-nrow(dat2)
be2004simu<-nrow(dat2)

prop.test(c(be2004simu,be2004jitu),c(be2000simu,be2000jitu),correct = FALSE)


data<-read.csv(filename,header = FALSE)


dat<-subset(data,data$V1==year)
dat<-subset(dat,dat$V6>0.0001)
colnames(dat)[4]<-"sp"
dat$sp[dat$sp==1]<-"Larix_cajanderi"
dat$sp[dat$sp==2]<-"Betula_platyphylla"
dat$sp[dat$sp==3]<-"Populus_tremula"


dat$BA<-dat$V6^2*pi/40000
dat1<-subset(dat,dat$sp=="Larix_cajanderi")
dat2<-subset(dat,dat$sp=="Betula_platyphylla")
dat3<-subset(dat,dat$sp=="Populus_tremula")

mean(dat1$V6)
mean(dat2$V6)
mean(dat3$V6)
sd(dat1$V6)
sd(dat2$V6)
sd(dat3$V6)
sum(dat1$BA)
sum(dat2$BA)
sum(dat3$BA)


