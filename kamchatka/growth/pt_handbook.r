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

q_model<-lm(formula=dbh_mm~Age+si,data=qaspen)
summary(q_model)
plot(q_model)
plot(qaspen$dbh_mm,q_model$fitted.values)

model1<-lm(formula=dbh_cm~Age+si+Age*si,data=qaspen)
model2<-lm(formula=dbh_cm~Age+si+Age*si+0,data=qaspen)
summary(model1)
summary(model2)

model_hikaku1<-dredge(model1,rank="BIC")
model_hikaku2<-dredge(model2,rank="BIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)
best_model<-lm(formula=dbh_cm~Age+si+Age*si+0,data=qaspen)
summary(best_model)

#outcsv<-"growth/growth_pt0917.csv"
#write.csv(model_hikaku,outcsv)
#tablecsv(best_model,qaspen,outcsv)

#residFun <- function(p, observed, x) observed - getPred(p, x)

#getPred <- function(parS,x){
#  parS$int+parS$a1*x$Age^parS$a2+parS$s1*x$si^parS$s2
#}


#parStart <- list(int=1,a1=1,a2=1,s1=1,s2=1)

#nls.yosokuchi <- nls.lm(par=parStart, fn = residFun, observed = qaspen$dbh_mm,
#                        x = qaspen, control=nls.lm.control(maxiter=1024,nprint=1))
#summary(nls.yosokuchi)

#x_forplot<-qaspen
#x_forplot$fit <- getPred(nls.yosokuchi$par,x_forplot)
#plot(x_forplot$dbh_mm,x_forplot$fit)

library(ggplot2)
pal <- c("#3B9AB2", "#56A6BA", "#71B3C2", "#9EBE91", "#D1C74C",
         "#E8C520", "#E4B80E", "#E29E00", "#EA5C00", "#F21A00")
g<-ggplot(data=qaspen,mapping=aes(x=Age, y=dbh_cm, col=si))+
  geom_point()+
  scale_color_gradientn(colors = pal)
print(g)
