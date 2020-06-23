#ワイブル分布
library(MASS)
library(survival)
install.packages("minpack.lm")
library(minpack.lm)
bunkatu1<-cut(int2$age,breaks=seq(5,30,by=1))
bunkatu2<-table(bunkatu1)
bunkatu3<-as.data.frame(bunkatu2)
bunkatu3$age<-c(5:29)
bunkatu_model1<-nls(formula=Freq~a*exp(-(b*age)^c),
                    data=bunkatu3,
                    start=c(a=5,b=0.5,c=0.05))




bunkatu_model1<-nls(formula=Freq~a*exp(-b*age),
                    data=bunkatu3,
                    start=c(a=5,b=0.8))


exp(10)

age_data1<-data.frame(age=seq(5,30,1))
a<-5
b<-0.5
c<-0.05
age_data1$Freq<-a*exp(-(b*age_data1$age)^c)
plot(age_data1$age,age_data1$Freq)





## values over which to simulate data 
#x <- seq(0,5,length=100)

## model based on a list of parameters 
getPred <- function(parS, xx) parS$a * exp(-(xx * parS$b)^parS$c)

## parameter values used to simulate data
#pp <- list(a=5,b=0.5, c=0.05) 

## simulated data, with noise  
#simDNoisy <- getPred(pp,x) + rnorm(length(x),sd=.1)

## plot data
#plot(x,simDNoisy, main="data")

## residual function 
residFun <- function(p, observed, xx) observed - getPred(p,xx)

## starting values for parameters  
parStart <- list(a=7,b=0.5, c=0.05)

## perform fit 
nls.out <- nls.lm(par=parStart, fn = residFun, observed = bunkatu3$Freq,
                  xx = bunkatu3$age, control=nls.lm.control(maxiter=1024,nprint=1))
nls.out
nls_a<-nls.out$par$a
nls_b<-nls.out$par$b
nls_c<-nls.out$par$c

plot(bunkatu3$age, bunkatu3$Freq)
x <- seq(5, 29, by=1)
x.pred <- nls_a * exp(-(x * nls_b)^nls_c)

lines(x, x.pred, col=2)


