library(MASS)
library(minpack.lm)

data<-read.csv("yuzurun.csv",fileEncoding = "UTF-8-BOM")

#Manaduru<-subset(CinnamonR,CinnamonR$Age=="VeryOld")　#Ａｇｅごとのデータセット

residFun <- function(p, observed, xx) observed - getPred(p,xx)

getPred<-function(parS,xx){
#  ifelse(parS$h<xx, parS$a*parS$h^parS$b, parS$a*xx^parS$b)
  parS$h*(1-exp(-parS$a*xx^parS$b))
}
parStart<-list(a=10,b=0.1,h=10)


nls.out <- nls.lm(par=parStart, fn = residFun, observed = data$樹高.ｍ.,
                  xx = data$胸高直径.cm., control=nls.lm.control(maxiter=1024,nprint=1))
summary(nls.out)



#可視化
x_forplot <- data.frame(x=seq(0,max(data$胸高直径.cm.) , by=0.1))
x_forplot$fit <- getPred(nls.out$par,x_forplot$x)

plot(data$胸高直径.cm.,data$樹高.ｍ.)
lines(x_forplot$x, x_forplot$fit, col=2)
