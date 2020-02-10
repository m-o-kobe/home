#bp解析用
library(doBy)
library("stringr")
motofire<-read.csv("fire_maiboku.csv", fileEncoding = "UTF-8-BOM")
fire_sprout1<-read.csv("fire_bp_sprout.csv", fileEncoding = "UTF-8-BOM")
fire1<-motofire
#fire1$xx<-as.numeric(fire1$grid..x.)+as.numeric(as.character(fire1$x))
#fire1$yy<-as.numeric(fire1$grid..y.)+as.numeric(as.character(fire1$y))
fire1$DBH00cm[is.na(fire1$DBH00cm)]<-0
fire1$GBH00cmn[is.na(fire1$GBH00cmn)]<-0
fire1$dbh0<-as.numeric(fire1$DBH00cm)+as.numeric(fire1$GBH00cmn)/acos(-1)
fire1$da<-0
fire1$da[fire1$D.A..2000.=="A"]<-1


parent_bp<-subset(fire1,fire1$sp.=="Be")
parent_bp$color<-"0"
parent_bp$color[str_sub(parent_bp$number,start=1,end=1)=="B"]<-"b"
parent_bp$color[str_sub(parent_bp$number,start=1,end=1)=="b"]<-"b"
parent_bp$color[str_sub(parent_bp$number,start=1,end=1)=="Y"]<-"y"
parent_bp$color[str_sub(parent_bp$number,start=1,end=1)=="y"]<-"y"
parent_bp$num<-as.character(parent_bp$number)
parent_bp$num[parent_bp$color=="b"]<-str_sub(parent_bp$number[parent_bp$color=="b"],start=2)
parent_bp$num[parent_bp$color=="y"]<-str_sub(parent_bp$number[parent_bp$color=="y"],start=2)


parent_bp$sprout..old.<-as.character(parent_bp$sprout..old.)
parent_bp$sprout..old.[is.na(parent_bp$sprout..old)]<-as.character(parent_bp$num)[is.na(parent_bp$sprout..old)]
parent_bp$sprout..old.[parent_bp$sprout..old==""]<-as.character(parent_bp$num)[parent_bp$sprout..old==""]
parent_bp<-subset(parent_bp,parent_bp$color!="y")
parent_bp$color<-"b"
parent_bp$ba<-pi*parent_bp$dbh0^2
parent_bp$survival_ba<-parent_bp$ba*parent_bp$da



juvenile1<-fire_sprout1
juvenile1$parent_num1<-as.character(fire_sprout1$parent_num)
juvenile1$parent_color<-"b"
juvenile1$juvenile_ba<-pi*juvenile1$X04DBHmm^2
#as.character(juvenile1$parent_num1)
len1<-nrow(juvenile1)
len2<-nrow(parent_bp)
for(i in 1:len1){
  for(j in 1:len2){
    if((juvenile1$parent_color[i]==parent_bp$color[j])&(juvenile1$parent_num[i]==parent_bp$num[j])){
      juvenile1$parent_num1[i]<-as.character(parent_bp$sprout..old.[j])
      break
    }
  }
}


juvenile2<-juvenile1[,c(-2)]
sum_parent<-summaryBy(formula = dbh0+da+ba+survival_ba~color+sprout..old.,data=parent_bp,FUN=c(mean,length))
sum_juvenile<-summaryBy(formula = X04DBHmm+juvenile_ba~parent_color+parent_num1,data=juvenile2,FUN=c(mean,length))
names(sum_parent)[ which( names(sum_parent)=="sprout..old." ) ] <- "parent_num1"
names(sum_parent)[ which( names(sum_parent)=="color" ) ] <- "parent_color"

sum_parent$survival_num<-sum_parent$dbh0.length*sum_parent$da.mean
sum_parent$ba<-sum_parent$ba.mean*sum_parent$ba.length
sum_parent$survivalba<-0
sum_parent$survivalba[sum_parent$survival_ba.mean>0.01]<-sum_parent$survival_ba.mean[sum_parent$survival_ba.mean>0.01]/sum_parent$da.mean[sum_parent$survival_ba.mean>0.01]
  
sum_parent1<-sum_parent[c(1,2,3,4,7,11,12,13)]
sum_juvenile$sum_ba<-sum_juvenile$juvenile_ba.mean*sum_juvenile$juvenile_ba.length
sum_juvenile3<-sum_juvenile[c(1,2,3,5,7)]

sum1<-merge(sum_parent1,sum_juvenile3,by=c("parent_num1","parent_color"),all = TRUE)
sum2<-merge(sum_parent,sum_juvenile,by=c("parent_num1","parent_color"))
#sum3<-subset(sum1,is.na(sum1$dbh0.mean))
sum4<-subset(sum1,!is.na(sum1$dbh0.mean))

sum41<-sum4[,c(-1,-2)]



colnames(sum41)<-c("parent_dbh",
                   "parent_survival_rate",
                   "parent_num",
                   "parent_survival_num",
                   "parent_ba",
                   "parent_survival_ba",
                   "juv_dbh",
                   "juv_num",
                   "juv_ba")


sum41$juv_dbh[is.na(sum41$juv_dbh)]<-0
sum41$juv_num[is.na(sum41$juv_num)]<-0
sum41$juv_ba[is.na(sum41$juv_ba)]<-0
sum41$da<-"a"
sum41$da[sum41$juv_ba==0]<-"d"



library(ggplot2)
g<-ggplot(data=sum41,
          mapping=aes(x=parent_num,fill=da))+
  geom_histogram(position = "dodge")
print(g)

g1<-ggplot(data=sum41,
          mapping=aes(x=da,y=parent_num,fill=da))+
  geom_violin()
print(g1)

yy<-ifelse(sum41$da == "a", 1, 0)

model1<-glm(formula=yy~sum41$parent_num+sum41$parent_dbh+sum41$parent_num*sum41$parent_dbh,family=binomial)
summary(model1)
model2<-step(model1)
summary(model2)

f<- function(x){1/(1+exp(-(int+trend*x)))}
plot(sum41$parent_ba,yy,main="seizonritu")
int<-model1$coefficients[1]
trend<-model1$coefficients[2]
curve(f, xlim=c(0,2200),add=T)

#ここから生存木だけの解析
alive<-subset(sum41,sum41$da=="a")
sum42<-alive[c(-10)]

library(GGally)
test<-data.frame

#col<-colnames(sum41)
#↓死亡木のみを解析する場合
k=1
plotList <- list()
name1<-colnames(sum42)
for(i in 1:6){
  for (j in 7:9){
    xmax<-max(sum42[i])
    ymax<-max(sum42[j])
    plotList[[k]]<-ggplot(data=sum42,aes_string(x=name1[i],y=name1[j]))+
      geom_point()+
      geom_text(x=xmax/2,
                y=ymax/2,
                label=as.character(round(cor(sum42[i],sum42[j],method ="spearman"),digits=4)),alpha=0.5,color="blue")
    k<-k+1
  }
}
pm<-ggmatrix(plotList,
             nrow=6,ncol=3,
             xAxisLabels = name1[1:6],
             yAxisLabels=name1[7:9],
             byrow = FALSE)
print(pm)

model3<-lm(formula=juv_num~parent_dbh+parent_num,data=sum42)
summary(model3)
par(mfrow=c(2,2))
plot(model3)
par(mfrow=c(1,1))

plot(model3$fitted.values,sum42$juv_num)
