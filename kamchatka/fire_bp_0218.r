#bp解析用
library(doBy)
library("stringr")
library(ggplot2)
library(GGally)
motofire<-read.csv("fire_maiboku0212.csv")
fire1<-motofire
fire1$xx<-as.numeric(fire1$grid..x.)+
  5*as.integer(as.numeric(as.character(fire1$x))/5)
fire1$yy<-as.numeric(fire1$grid..y.)+
  5*as.integer(as.numeric(as.character(fire1$y))/5)

#fire1$yy<-as.numeric(fire1$grid..y.)+as.numeric(as.character(fire1$y))
fire1$DBH00cm[is.na(fire1$DBH00cm)]<-0
fire1$GBH00cmn[is.na(fire1$GBH00cmn)]<-0
fire1$dbh0<-as.numeric(fire1$DBH00cm)+as.numeric(fire1$GBH00cmn)/acos(-1)
fire1$da<-0
fire1$da[fire1$D.A..2000.=="A"]<-1




parent_bp<-subset(fire1,fire1$sp.=="Be")
parent_bp$ba<-pi*parent_bp$dbh0^2
parent_bp$survival_ba<-parent_bp$ba*parent_bp$da


children<-read.csv("5m_poplus_datateisei.csv",fileEncoding = "UTF-8-BOM")
juv1<-children[c("x","y","Be_sucker2002","Be_sucker2000")]



#juvenile1<-fire_sprout1
#juvenile1$parent_num1<-as.character(fire_sprout1$parent_num)
#juvenile1$parent_color<-"b"
#juvenile1$juvenile_ba<-pi*juvenile1$X04DBHmm^2
#as.character(juvenile1$parent_num1)


juvenile2<-juvenile1[,c(-2)]
sum_parent<-summaryBy(formula = dbh0+da+ba+survival_ba+fire_intense~xx+yy,data=parent_bp,FUN=c(mean,length))
names(juv1)[ which( names(juv1)=="x" ) ] <- "xx"
names(juv1)[ which( names(juv1)=="y" ) ] <- "yy"


sum_parent$survival_num<-sum_parent$dbh0.length*sum_parent$da.mean
sum_parent$ba<-sum_parent$ba.mean*sum_parent$ba.length
sum_parent$survivalba<-0
sum_parent$survivalba[sum_parent$survival_ba.mean>0.01]<-sum_parent$survival_ba.mean[sum_parent$survival_ba.mean>0.01]/sum_parent$da.mean[sum_parent$survival_ba.mean>0.01]

sum_parent1<-sum_parent[c(1,2,3,4,7,11,12,13)]
sum_parent1<-sum_parent[c(1,2,3,4,5,6,7,8)]
sum_parent1$parent_ba<-sum_parent1$ba.mean*sum_parent$dbh0.length


sum1<-merge(sum_parent1,juv1,by=c("xx","yy"),all = TRUE)
sum2<-merge(sum_parent,sum_juvenile,by=c("parent_num1","parent_color"))
#sum3<-subset(sum1,is.na(sum1$dbh0.mean))

sum41<-sum1[,c(-1,-2,-4,-5,-6,-7)]



colnames(sum41)<-c("parent_dbh",
                   "parent_num",
                   "parent_ba",
                   "be_2002",
                   "be_2000")


sum41$parent_dbh[is.na(sum41$parent_dbh)]<-0
sum41$parent_num[is.na(sum41$parent_num)]<-0
sum41$parent_ba[is.na(sum41$parent_ba)]<-0


#sum41$da<-"a"
#sum41$da[sum41$juv_ba==0]<-"d"



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

col<-colnames(sum41)
#↓死亡木のみを解析する場合
sum42<-subset(sum41,!is.na(sum41$be_2002))
sum41<-sum42
k=1
plotList <- list()
name1<-colnames(sum41)
for(i in 1:3){
  for (j in 4:5){
    xmax<-max(sum41[i])
    ymax<-max(sum41[j])
    plotList[[k]]<-ggplot(data=sum41,aes_string(x=name1[i],y=name1[j]))+
      geom_point()+
      geom_text(x=xmax/2,
                y=ymax/2,
                label=as.character(round(cor(sum41[i],sum41[j],method ="spearman"),digits=4)),alpha=0.5,color="blue")
    k<-k+1
  }
}
pm<-ggmatrix(plotList,
             nrow=2,ncol=3,
             xAxisLabels=name1[1:3],
             yAxisLabels=name1[4:5],
             byrow = FALSE)
print(pm)
plot(sum41$be_2000,sum41$be_2002)





#sum42<-subset(sum41,sum41$juv_num>0)
#model3<-lm(formula=juv_num~parent_dbh+parent_num+fire+parent_survival_rate,data=sum42)
bp_sum<-sum41
bp_sum$parent_num<-sum41$parent_num-1


model_4<-lm(formula=juv_num~parent_dbh+parent_num+fire+parent_survival_rate-1,data=bp_sum)
summary(model_4)
model_4<-step(model_4,k=log(nrow(bp_sum)))
plot(model_4$fitted.values,bp_sum$juv_num)
summary(model_4$fitted.values)

df<-cbind(bp_sum,model_4$fitted.values)





model3<-lm(formula=juv_num~parent_dbh+parent_num+fire+parent_survival_rate-1,data=sum41)
summary(model3)
model3<-step(model3,k=log(nrow(sum41)))
plot(model3$fitted.values,sum41$juv_num)


summary(model3)

par(mfrow=c(2,2))

plot(model_4)
par(mfrow=c(1,1))

plot(model3$fitted.values,sum41$juv_num)

df<-cbind(sum41,model3$fitted.values)
