#https://www.nrs.fs.fed.us/pubs/gtr/gtr_nc036.pdf
#↑のtable10,11を利用
library(MASS)
library(minpack.lm)
library(MuMIn)
options(na.action = "na.fail")
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
    result[2:nrow(result),5:6] <- ""
  }
  
  write.table(matrix(c("\n",colnames(result)),nrow=1),ou,append=T,quote=F,sep=","
              ,row.names=F,col.names=F)
  write.table(result,ou,append=T,quote=F,sep=",",row.names=T,col.names=F)
}




motodata<-read.csv("ronbun/aspen_handbook10.csv",fileEncoding = "UTF-8-BOM")
qaspen<-subset(motodata,motodata$spp=="quaking")
plot(qaspen$Age,qaspen$dbh_inch)
plot(qaspen$si,qaspen$dbh_inch)


model1<-lm(formula=dbh_inch~Age+si+Age*si,data=qaspen)
model2<-lm(formula=dbh_inch~Age+si+Age*si+0,data=qaspen)
summary(model1)
summary(model2)

model_hikaku1<-dredge(model1,rank="BIC")
model_hikaku2<-dredge(model2,rank="BIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)
best_model<-lm(formula=dbh_inch~Age+si+Age*si+0,data=qaspen)
summary(best_model)

#outcsv<-"growth/growth_pt_inch0917.csv"
#write.csv(model_hikaku,outcsv)
#tablecsv(best_model,qaspen,outcsv)
coef_model<-best_model$coefficients

#si<-51
growth<-coef_model[1]+si*coef_model[3]
#site indexを指定した場合の1年あたりの成長量(インチ)

