#bp解析用
library(doBy)
motofire<-read.csv("fire.csv")
fire_sprout1<-read.csv("fire_bp_sprout.csv", fileEncoding = "UTF-8-BOM")
fire1<-motofire
fire1$xx<-as.numeric(fire1$grid..x.)+as.numeric(as.character(fire1$x))
fire1$yy<-as.numeric(fire1$grid..y.)+as.numeric(as.character(fire1$y))
fire1$DBH00cm[is.na(fire1$DBH00cm)]<-0
fire1$GBH00cmn[is.na(fire1$GBH00cmn)]<-0
fire1$dbh0<-as.numeric(fire1$DBH00cm)+as.numeric(fire1$GBH00cmn)/acos(-1)
fire1$da<-0
fire1$da[fire1$D.A..2000.=="A"]<-1

parent_bp<-subset(fire1,fire1$sp.=="Be")


parent_bp$sprout..old.<-as.character(parent_bp$sprout..old.)
parent_bp$sprout..old.[parent_bp$sprout..old==""]<-as.character(parent_bp$number)

sprout<-fire_sprout1
sprout$xx<-sprout$X+sprout$x
sprout$yy<-sprout$Y+sprout$y

sum_parent<-summaryBy(formula = dbh0+da~color+oldsprout,data=parent_bp,FUN=c(mean,length))
sum_juvenile<-summaryBy(formula = X04DBHmm~parent_color+parent_num,data=sprout,FUN=c(mean,length))
names(sum_parent)[ which( names(sum_parent)=="oldsprout" ) ] <- "parent_num"
names(sum_parent)[ which( names(sum_parent)=="color" ) ] <- "parent_color"

sum1<-merge(sum_parent,sum_juvenile,by=c("parent_num","parent_color"),all = TRUE)
sum2<-merge(sum_parent,sum_juvenile,by=c("parent_num","parent_color"))
sum3<-subset(sum1,is.na(sum1$dbh0.mean))

library(dplyr)

sum21<-data.frame
sum21<sum2[,c(3,5,7,8)]
sum21<-select(sum2,3,5,7,8)
colnames(sum21)<-c("parent_dbh","parent_num","juvenile_dbh","juvenile_num")
library(GGally)
g<-ggpairs(data=sum21)
print(g)
write.csv(sum2, "bp_fire_pj.csv")
write.csv(sum1, "bp_fire_pj2.csv")


sum_parent[7,2]
sum_juvenile[7,2]