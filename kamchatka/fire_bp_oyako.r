#bp解析用
library(doBy)
library("stringr")
motofire<-read.csv("fire_maiboku0302.csv")
fire_sprout1<-read.csv("fire_bp_sprout.csv", fileEncoding = "UTF-8-BOM")
fire1<-motofire
#fire1<-fire4
#fire1$xx<-as.numeric(fire1$grid..x.)+as.numeric(as.character(fire1$x))
#fire1$yy<-as.numeric(fire1$grid..y.)+as.numeric(as.character(fire1$y))
fire1$DBH00cm[is.na(fire1$DBH00cm)]<-0
fire1$GBH00cmn[is.na(fire1$GBH00cmn)]<-0
fire1$dbh0<-as.numeric(fire1$DBH00cm)+as.numeric(fire1$GBH00cmn)/acos(-1)
fire1$da<-0
fire1$da[fire1$D.A..2000.=="A"]<-1
#plot(fire1$grid..x.,fire1$grid..y.)
#plot(fire_sprout1$X,fire_sprout1$Y)

tablecsv<-function(datalm,data,ou){
  sum<-summary(datalm)
  coe <- sum$coefficient
  N <- nrow(data)
  AIC <- AIC(datalm)
  R_squared<-sum$r.squared
  adjusted_R_squared<-sum$adj.r.squared
  
  result <- cbind(coe,AIC,N,R_squared,adjusted_R_squared)
  ro<-nrow(result)
  if(ro>1){
    result[2:nrow(result),5:8] <- ""
  }
  
  write.table(matrix(c("\n",colnames(result)),nrow=1),ou,append=T,quote=F,sep=","
              ,row.names=F,col.names=F)
  write.table(result,ou,append=T,quote=F,sep=",",row.names=T,col.names=F)
}

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
sum_parent<-summaryBy(formula = dbh0+da+ba+survival_ba+fire~color+sprout..old.,data=parent_bp,FUN=c(mean,length))
sum_juvenile<-summaryBy(formula = X04DBHmm+juvenile_ba~parent_color+parent_num1,data=juvenile2,FUN=c(mean,length))
names(sum_parent)[ which( names(sum_parent)=="sprout..old." ) ] <- "parent_num1"
names(sum_parent)[ which( names(sum_parent)=="color" ) ] <- "parent_color"

sum_parent$survival_num<-sum_parent$dbh0.length*sum_parent$da.mean
sum_parent$ba<-sum_parent$ba.mean*sum_parent$ba.length
sum_parent$survivalba<-0
sum_parent$survivalba[sum_parent$survival_ba.mean>0.01]<-sum_parent$survival_ba.mean[sum_parent$survival_ba.mean>0.01]/sum_parent$da.mean[sum_parent$survival_ba.mean>0.01]
  
#sum_parent1<-sum_parent[c(1,2,3,4,7,11,12,13)]
sum_parent1<-sum_parent[c(1,2,3,4,5,6,7,8)]
sum_parent1$parent_ba<-sum_parent1$ba.mean*sum_parent$dbh0.length

sum_juvenile$sum_ba<-sum_juvenile$juvenile_ba.mean*sum_juvenile$juvenile_ba.length
sum_juvenile3<-sum_juvenile[c(1,2,3,5,7)]

sum1<-merge(sum_parent1,sum_juvenile3,by=c("parent_num1","parent_color"),all = TRUE)
sum2<-merge(sum_parent,sum_juvenile,by=c("parent_num1","parent_color"))
#sum3<-subset(sum1,is.na(sum1$dbh0.mean))
sum4<-subset(sum1,!is.na(sum1$dbh0.mean))

sum41<-sum4[,c(-1,-2,-5,-6,-9,-12)]



colnames(sum41)<-c("parent_dbh",
                   "parent_survival_rate",
                   "fire",
                   "parent_num",
                   "juv_dbh",
                   "juv_num")


sum41$juv_dbh[is.na(sum41$juv_dbh)]<-0
sum41$juv_num[is.na(sum41$juv_num)]<-0
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

#sum42<-subset(sum41,sum41$juv_num>0)
#model3<-lm(formula=juv_num~parent_dbh+parent_num+fire+parent_survival_rate,data=sum42)
bp_sum<-sum41
bp_sum$parent_num<-sum41$parent_num-1


#model_4<-lm(formula=juv_num~parent_dbh+parent_num+fire+parent_survival_rate-1,data=bp_sum)
#model_4<-lm(formula=juv_num~parent_dbh+parent_num+fire+parent_survival_rate+
#              parent_dbh*parent_num+parent_dbh*fire+parent_dbh*parent_survival_rate+
#              parent_num*fire+parent_num*parent_survival_rate+
#              fire*parent_survival_rate-1,data=bp_sum)
library(MuMIn)
options(na.action = "na.fail")
model_1<-lm(formula=juv_num~parent_dbh*parent_num*fire*parent_survival_rate-1,data=bp_sum)
model_2<-lm(formula=juv_num~parent_dbh*parent_num*fire*parent_survival_rate,data=bp_sum)
model_hikaku1<-dredge(model_1,rank="BIC")
model_hikaku2<-dredge(model_2,rank="BIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)

write.csv(model_hikaku,"bp_fire_kabugoto0302_2.csv")


tablecsv(model_6,bp_sum,"bp_fire_kabugoto0302.csv")

#model_5<-step(model_4,k=log(nrow(bp_sum)))
#summary(model_5)
#plot(model_4$fitted.values,bp_sum$juv_num)

model_5<-dredge(model_4,rank="BIC")
best.model <- get.models(model_hikaku, subset = 1)[1]
best.model_<-best.model$`24.x`
model_6<-lm(best.model_$call,data=bp_sum)
summary(model_6)
tablecsv(model_6,bp_sum,"bp_fire_kabugoto0302_2.csv")

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
