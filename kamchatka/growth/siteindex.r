library(MASS)
library(minpack.lm)

nenrin<-read.csv("growth/nenrin_hgt.csv",fileEncoding = "UTF-8-BOM")
nenrin_pt<-subset(nenrin,nenrin$spp=="pt")

nenrin_pt<-subset(nenrin_pt,!is.na(nenrin_pt$age))

nenrin_pt<-subset(nenrin_pt,nenrin_pt$hgt>=7.1)

parStart<-list(b1=2.07,b2=-0.0077,b3=0.93)
residFun <- function(p, observed, xx) observed - getPred(p,xx)
getPred<-function(parS,xx){
#  ifelse(parS$h<xx, parS$a*parS$h^parS$b, parS$a*xx^parS$b)
  #4.5+parS$b1*(1-parS$b2*exp(1)^(parS$b3*xx))^parS$b4
  1.3+parS$b1*(1-exp(1)^(parS$b2*xx))^parS$b3
  
}


nls.out <- nls.lm(par=parStart, fn = residFun, observed = nenrin_pt$hgt,
                  xx = nenrin_pt$age, control=nls.lm.control(maxiter=1024,nprint=1))
summary(nls.out)
x_forplot <- data.frame(age=seq(20, 90, by=1))
#x_forplot$fit <- nls_a*exp((-x+nls_mu)/nls_sigma)/(1+exp((-x+nls_mu)/nls_sigma))
x_forplot$height <- getPred(nls.out$par,x_forplot$age)

plot(nenrin_pt$age,nenrin_pt$hgt)

lines(x_forplot$x,x_forplot$fit)


ronbunpar<-list(b1=2.07151,b2=-0.007719,b3=0.93972)
ronbunPred<-function(parS,s,xx){
  #  ifelse(parS$h<xx, parS$a*parS$h^parS$b, parS$a*xx^parS$b)
  #4.5+parS$b1*(1-parS$b2*exp(1)^(parS$b3*xx))^parS$b4
  4.5+parS$b1*(s-4.5)*(1-exp(1)^(parS$b2*xx))^parS$b3
  
}
ronbunPred(ronbunpar,50,80)

ronbun_hyou <- data.frame(si80=seq(30, 60, by=1))
#x_forplot$fit <- nls_a*exp((-x+nls_mu)/nls_sigma)/(1+exp((-x+nls_mu)/nls_sigma))
ronbun_hyou$si50 <- ronbunPred(ronbunpar,ronbun_hyou$si80,50)

write.csv(ronbun_hyou,"growth/si80_si50.csv")

plot(ronbun_hyou$si80,ronbun_hyou$si50)


sum<-summary(nls.out)
tablecsv<-function(datalm,data,ou){
  sum<-summary(datalm)
  coe <- sum$coefficient
  N <- nrow(data)
  #AIC <- AIC(datalm)
  #R_squared<-sum$r.squared
  #adjusted_R_squared<-sum$adj.r.squared
  
  result <- cbind(coe,N)
  ro<-nrow(result)
  if(ro>1){
    result[2:nrow(result),5] <- ""
  }
  
  write.table(matrix(c("\n",colnames(result)),nrow=1),ou,append=T,quote=F,sep=","
              ,row.names=F,col.names=F)
  write.table(result,ou,append=T,quote=F,sep=",",row.names=T,col.names=F)
}

#tablecsv(nls.out,nenrin_pt,"growth/height_age.csv")
