library(MASS)
library(minpack.lm)

CinnamonR<-read.csv("200616CinnamonR.csv")

Manaduru<-subset(CinnamonR,CinnamonR$Age=="VeryOld")　#Ａｇｅごとのデータセット

residFun <- function(p, observed, xx) observed - getPred(p,xx)

getPred<-function(parS,xx){
  ifelse(parS$h<xx, parS$a*parS$h^parS$b, parS$a*xx^parS$b)
}
parStart<-list(a=50,b=0.5,h=10)


nls.out <- nls.lm(par=parStart, fn = residFun, observed = Manaduru$Dh,
                  xx = Manaduru$L.m., control=nls.lm.control(maxiter=1024,nprint=1))
summary(nls.out)



#可視化
x_forplot <- data.frame(x=seq(0, 30, by=0.1))
x_forplot$fit <- getPred(nls.out$par,x_forplot$x)

plot(Manaduru$L.m.,Manaduru$Dh)
lines(x_forplot$x, x_forplot$fit, col=2)
