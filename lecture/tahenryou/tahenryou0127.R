df1<-read.csv("challenger.csv",fileEncoding = "UTF-8-BOM")
df1$koshou<-df1$nf/df1$no
data0<-df1
yy<-cbind(data0$nf, data0$no-data0$nf)

model1<-glm(formula=yy~df1$temp,family=binomial)
summary(model1)
int<-model1$coefficients[1]
trend<-model1$coefficients[2]
f<- function(x){1/(1+exp(-(int+trend*x)))}

plot(x=df1$temp,y=df1$koshou,xlim=c(30,85),ylim=c(0,1))
curve(f, xlim=c(30,85),add=T)

model2<-glm(formula=yy~df1$temp,family=binomial(link = "probit"))
summary(model2)
int2<-model2$coefficients[1]
trend2<-model2$coefficients[2]
f2 <- function(x) {pnorm(int2+trend2*x)}

model3<-glm(formula=yy~df1$temp,family=binomial(link = "cloglog"))
summary(model3)
int3<-model3$coefficients[1]
trend3<-model3$coefficients[2]
f3 <- function(x) {1 - exp(- exp(int3+trend3*x))}


plot(x=df1$temp,y=df1$koshou,xlim=c(30,85),ylim=c(0,1))
curve(f, xlim=c(30,85),add=T,col="red")
curve(f2, xlim=c(30,85),add=T,col="blue")
curve(f3, xlim=c(30,85),add=T,col="green")

f(31)
f2(31)
f3(31)