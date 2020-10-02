library(MASS)
library(survival)
library(minpack.lm)

motodata<-read.csv("nenrin/nenrin1.csv")
sp<-"pt"
data1<-subset(motodata,motodata$spp==sp)
model<-lm(age~dbh,data=data1)

int<-read.csv("int0313.csv")
int1<-subset(int,int$spp==sp)
int1$dbh<-int1$dbh01*10
int1$age<-predict(model,int1)

int2<-subset(int1,int1$age<=30)


bunkatu1<-cut(int2$age,breaks=seq(5,30,by=1))
bunkatu2<-table(bunkatu1)
bunkatu3<-as.data.frame(bunkatu2)
bunkatu3$age<-c(5:29)
getHazard<-function(parS,xx) (getPred(parS,xx)-getPred(parS,xx+1))/getPred(parS,xx)


#ワイブル分布

getPred <- function(parS, xx) parS$a * exp(- parS$lambda*xx^parS$k)
residFun <- function(p, observed, xx) observed - getPred(p,xx)
parStart <- list(a=7,lambda=0.5, k=0.05)
nls.out <- nls.lm(par=parStart, fn = residFun, observed = bunkatu3$Freq,
                  xx = bunkatu3$age, control=nls.lm.control(maxiter=1024,nprint=1))
sink("mortality/poplus_weibull0621.txt")
print(getPred)
summary(nls.out)
nls.out
sink()


#可視化
x_forplot <- data.frame(x=seq(0, 29, by=1))
#x_forplot$fit <- nls_a*exp((-x+nls_mu)/nls_sigma)/(1+exp((-x+nls_mu)/nls_sigma))
x_forplot$fit <- getPred(nls.out$par,x_forplot$x)
x_forplot$hazard <- getHazard(nls.out$par,x_forplot$x)
plot(x=bunkatu3$age,y=bunkatu3$Freq,
     ylab="個体数",xlab="齢",
     main="Survival(red) hazard(blue)")
lines(x_forplot$x, x_forplot$fit, col=2)
par(new = T)
plot(
  x=x_forplot$x,y=x_forplot$hazard,
  type="l",
  axes=FALSE,
  xlab="",
  ylab="",
  ylim = c(0,1),
  col="blue"
  
)
axis(4)
mtext("死亡率", #2軸目のラベル名
      side = 4, #どこにラベルを置くか(1なら下,2なら左,3なら上,4なら右)
      #line = 2 #グラフの枠からの距離
)


sink("mortality/poplus_weibull0621.txt")
print(getPred)
print(nls.out)
summary(nls.out)
sink()








#対数正規分布
getPred <- function(parS, xx) parS$a*(1-pnorm((log(xx)-parS$mu)/parS$sigma))
#parS$a * exp(-(xx * parS$b)^parS$c)

#residFun <- function(p, observed, xx) observed - getPred(p,xx)
residFun <- function(p, observed, xx) observed - getPred(p,xx)

parStart <- list(a=3,mu=3,sigma=0.2)
nls.out <- nls.lm(par=parStart, fn = residFun, observed = bunkatu3$Freq,
                  xx = bunkatu3$age, control=nls.lm.control(maxiter=1024,nprint=1))
nls.out







#可視化
x_forplot <- data.frame(x=seq(0, 29, by=1))

#x_forplot$fit <- nls_a*exp((-x+nls_mu)/nls_sigma)/(1+exp((-x+nls_mu)/nls_sigma))
x_forplot$fit <- getPred(nls.out$par,x_forplot$x)
x_forplot$hazard <- getHazard(nls.out$par,x_forplot$x)
plot(x=bunkatu3$age,y=bunkatu3$Freq,
     ylab="個体数",xlab="齢",
     main="Survival(red) hazard(blue)")
lines(x_forplot$x, x_forplot$fit, col=2)
par(new = T)
plot(
  x=x_forplot$x,y=x_forplot$hazard,
  type="l",
  axes=FALSE,
  xlab="",
  ylab="",
  ylim = c(0,1),
  col="blue"
  
)
axis(4)
mtext("死亡率", #2軸目のラベル名
      side = 4, #どこにラベルを置くか(1なら下,2なら左,3なら上,4なら右)
      #line = 2 #グラフの枠からの距離
)


sink("mortality/poplus_log_normal0621.txt")
print(getPred)
print(nls.out)
summary(nls.out)
sink()





#logistic
getPred <- function(parS, xx) parS$a*exp((-xx+parS$mu)/parS$sigma)/(1+exp((-xx+parS$mu)/parS$sigma))

#parS$a * exp(-(xx * parS$b)^parS$c)

#residFun <- function(p, observed, xx) observed - getPred(p,xx)
residFun <- function(p, observed, xx) observed - getPred(p,xx)

parStart <- list(a=3,mu=3,sigma=0.2)
nls.out <- nls.lm(par=parStart, fn = residFun, observed = bunkatu3$Freq,
                  xx = bunkatu3$age, control=nls.lm.control(maxiter=1024,nprint=1))
nls.out


x_forplot <- data.frame(x=seq(0, 29, by=1))
#x_forplot$fit <- nls_a*exp((-x+nls_mu)/nls_sigma)/(1+exp((-x+nls_mu)/nls_sigma))
x_forplot$fit <- getPred(nls.out$par,x_forplot$x)
x_forplot$hazard <- getHazard(nls.out$par,x_forplot$x)


#可視化
plot(x=bunkatu3$age,y=bunkatu3$Freq,
     ylab="個体数",xlab="齢",
     main="Survival(red) hazard(blue)")
lines(x_forplot$x, x_forplot$fit, col=2)
par(new = T)
plot(
  x=x_forplot$x,y=x_forplot$hazard,
  type="l",
  axes=FALSE,
  xlab="",
  ylab="",
  ylim=c(0,1),
  col="blue"
  
)
axis(4)
mtext("死亡率", #2軸目のラベル名
      side = 4, #どこにラベルを置くか(1なら下,2なら左,3なら上,4なら右)
      #line = 2 #グラフの枠からの距離
)


sink("mortality/poplus_logistic0621.txt")
print(getPred)
print(nls.out)
summary(nls.out)
sink()
