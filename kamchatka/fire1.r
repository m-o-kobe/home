#森林火災の影響確認用
library(ggplot2)
library(spatstat)

motofire<-read.csv("fire.csv")
fire1<-motofire
fire1$xx<-as.numeric(fire1$grid..x.)+as.numeric(as.character(fire1$x))
fire1$yy<-as.numeric(fire1$grid..y.)+as.numeric(as.character(fire1$y))
fire1$DBH00cm[is.na(fire1$DBH00cm)]<-0
fire1$GBH00cmn[is.na(fire1$GBH00cmn)]<-0
fire1$dbh00<-as.numeric(fire1$DBH00cm)+as.numeric(fire1$GBH00cmn)/acos(-1)

g <- ggplot(fire1, aes(x = dbh00, fill = sp.))
g <- g + geom_histogram(position = "dodge")
g <- g + scale_fill_npg()
plot(g)

fire2<-subset(fire1,fire1$D.A..2000.=="A")

g <- ggplot(fire2, aes(x = dbh00, fill = sp.))
g <- g + geom_histogram(position = "dodge")
g <- g + scale_fill_npg()
plot(g)

#生死比較


sp="Po"
fire3<-subset(fire1,fire1$sp.==sp)
fire3$da<-0
fire3$da[fire3$D.A..2000.=="A"]<-1
r2 = glm(da ~ dbh00, data=fire3, family=binomial(link="logit"))

x1.u <- seq(min(fire3$dbh00), max(fire3$dbh00), length.out = 100)
pred.x1 <- predict(r2, newdata = data.frame(dbh00 = x1.u),
                   type = "response")

plot(x = x1.u, y = pred.x1, type = "l",
     col = "red", lwd = 2, lty = 1,
     ylim = c(-0.05, 1.05), xlab = "x1", ylab = expression(theta),
     main=sp)
points(x = fire3$dbh00, y = fire3$da, 
       pch = 21, bg = rgb(0, 0, 0, 0.5), col = "black")
summary(r2)


g8<-ggplot(fire3, aes(x=dbh00,fill = D.A..2000.)) 
g8<-g8+geom_histogram(position="dodge")+
  ggtitle(sp)
plot(g8)

#200yrとの比較
data<-read.csv("ctrl0315.csv")
fire4<-select(fire1, c(sp.,dbh00))
ctr1<-select(data,c(spp,dbh01))
fire4$spp<-as.character(fire4$spp)

names(fire4)<-c("spp","dbh")
names(ctr1)<-c("spp","dbh")

fire4$spp[fire4$spp=="Be"]<-"bp"
fire4$spp[fire4$spp=="La"]<-"lc"
fire4$spp[fire4$spp=="Po"]<-"pt"
fire4$plot<-"2yr"
ctr1$plot<-"200yr"
cfdata1<-rbind(fire4,ctr1)

sp<-"pt"
cfdata2<-subset(cfdata1,cfdata1$spp==sp)
g <- ggplot(cfdata2, aes(x = dbh, fill = plot))
g <- g + geom_histogram(position = "dodge")
g <- g +ggtitle(sp)
plot(g)


