#bp解析用

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


#juvenile2<-juvenile1[,c(-2)]
sum_parent<-summaryBy(formula = dbh0+da+ba+survival_ba~xx+yy,data=parent_bp,FUN=c(mean,length))
names(juv1)[ which( names(juv1)=="x" ) ] <- "xx"
names(juv1)[ which( names(juv1)=="y" ) ] <- "yy"



sum_parent$survival_num<-sum_parent$dbh0.length*sum_parent$da.mean
sum_parent$ba<-sum_parent$ba.mean*sum_parent$ba.length
sum_parent$survivalba<-0
sum_parent$survivalba[sum_parent$survival_ba.mean>0.01]<-sum_parent$survival_ba.mean[sum_parent$survival_ba.mean>0.01]/sum_parent$da.mean[sum_parent$survival_ba.mean>0.01]

#sum_parent1<-sum_parent[c(1,2,3,4,7,11,12,13)]
sum_parent1<-sum_parent[c(1,2,3,4,5,6,7,8)]
sum_parent1$parent_ba<-sum_parent1$ba.mean*sum_parent$dbh0.length


sum1<-merge(sum_parent1,juv1,by=c("xx","yy"),all = TRUE)
#sum2<-merge(sum_parent,sum_juvenile,by=c("parent_num1","parent_color"))
#sum3<-subset(sum1,is.na(sum1$dbh0.mean))
#intensity3はfire_intensity1.rからとってくること

len=nrow(sum1)
for(i in 1:len){
  print(i)
  fire_intensity<-intensity3[as.integer(sum1$xx[i])+3,as.integer(sum1$yy[i])+3]
  sum1$fire[i]<-as.numeric(fire_intensity)
}
#↑のintensity3はfire_intensity1ファイルから出してくること

sum41<-sum1[,c(-1,-2,-4,-5,-6,-7)]



colnames(sum41)<-c("parent_dbh",
                   "parent_num",
                   "parent_ba",
                   "be_2002",
                   "be_2000",
                   "fire"
                   )
sum41<-sum41[c(1,2,3,6,4,5)]


sum41$parent_dbh[is.na(sum41$parent_dbh)]<-0
sum41$parent_num[is.na(sum41$parent_num)]<-0
sum41$parent_ba[is.na(sum41$parent_ba)]<-0
sum41<-subset(sum41,!is.na(sum41$be_2002))



library(MuMIn)
options(na.action = "na.fail")

model1<-lm(be_2000~parent_num*parent_dbh*fire,data=sum41)
model2<-lm(be_2000~parent_num*parent_dbh*fire-1,data=sum41)

summary(model1)
summary(model2)

model_hikaku1<-dredge(model1,rank="BIC")
model_hikaku2<-dredge(model2,rank="BIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)

best_model<-lm(be_2000~parent_num*parent_dbh+0,data=sum41)
summary(best_model)

#outcsv<-"regeneration/regene_fire_bp1106.csv"

#write.csv(model_hikaku,outcsv)

#tablecsv(best_model,sum41,outcsv)

