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
residFun <- function(p, observed, xx) observed - getPred(p,xx)

kansu<-"weibull"
kansu<-"log-normal"
kansu<-"logistic"
kansu<-"log-logistic"
kansu<-"normal"

if (kansu=="weibull"){
  #ワイブル分布
  getPred <- function(parS, xx) parS$a * exp(- parS$lambda*xx^parS$k)
  parStart <- list(a=7,lambda=0.5, k=0.05)
} else if (kansu=="log-normal"){
  #対数正規分布
  getPred <- function(parS, xx) parS$a*(1-pnorm((log(xx)-parS$mu)/parS$sigma))
  parStart <- list(a=3,mu=3,sigma=0.2)
  
} else if (kansu=="logistic"){
  #logistic
  getPred <- function(parS, xx) parS$a*exp((-xx+parS$mu)/parS$sigma)/(1+exp((-xx+parS$mu)/parS$sigma))
  parStart <- list(a=3,mu=3,sigma=0.2)
} else if(kansu=="log-logistic"){
  getPred<-function(parS,xx) parS$a/(1+parS$lambda*xx^parS$k)
  parStart<-list(a=4,lambda=3,k=1)
} else if(kansu=="normal"){
  getPred<-function(parS, xx) parS$a*(1-pnorm((xx-parS$mu)/parS$sigma))
  parStart<-list(a=4,mu=1,sigma=1)
}

nls.out <- nls.lm(par=parStart, fn = residFun, observed = bunkatu3$Freq,
                  xx = bunkatu3$age, control=nls.lm.control(maxiter=1024,nprint=1))




#可視化
x_forplot <- data.frame(x=seq(0, 29, by=1))
#x_forplot$fit <- nls_a*exp((-x+nls_mu)/nls_sigma)/(1+exp((-x+nls_mu)/nls_sigma))
x_forplot$fit <- getPred(nls.out$par,x_forplot$x)
x_forplot$hazard <- getHazard(nls.out$par,x_forplot$x)



plot(x=bunkatu3$age,y=bunkatu3$Freq,
     ylab="個体数",xlab="齢",
     main=kansu)
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
legend("topright",legend=c("個体数","死亡率"),lty=1,col=c("red","blue"))


#ファイル出力
outfile<-paste("mortality/poplus",kansu,"0624.txt")
sink(outfile)
print(getPred)
print(nls.out)
summary(nls.out)
sink()
