library(MASS)
library(survival)
library(minpack.lm)

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



motodata<-read.csv("nenrin/nenrin1.csv")

sp<-"bp"
nenrin1<-subset(motodata,motodata$spp==sp)
summary(nenrin1)
plot(nenrin1$dbh,nenrin1$age)
model1<-lm(age~dbh,data=nenrin1)
model2<-lm(age~dbh+0,data=nenrin1)
summary(model1)
summary(model2)

tablecsv(model1,nenrin1,"nenrin/nenrin_age_bp0115.csv")
tablecsv(model2,nenrin1,"nenrin/nenrin_age_bp0115.csv")


int<-read.csv("int0313.csv")
int_bp<-subset(int,int$spp==sp)
int_bp$dbh<-int_bp$dbh01*10
int_bp$age<-predict(model2,int_bp)

hist(int_bp$age)
hist(ctr_bp$age)


ctr<-read.csv("ctrl0315.csv")
ctr_bp<-subset(ctr,ctr$spp=="bp")
ctr_bp$dbh<-ctr_bp$dbh01*10
ctr_bp$age<-predict(model2,ctr_bp)

ketugou<-rbind(ctr_bp,int_bp)
hist(ketugou$age)

#1年毎
bunkatu1<-cut(ketugou$age,breaks=seq(0,120,by=1))
bunkatu2<-table(bunkatu1)
bunkatu3<-as.data.frame(bunkatu2)
bunkatu3$age<-c(0:119)
bunkatu3<-subset(bunkatu3,bunkatu3$age>4)



#bunkatu1<-cut(ketugou$age,breaks=seq(0,100,by=5))
#bunkatu2<-table(bunkatu1)
#bunkatu3<-as.data.frame(bunkatu2)
#bunkatu3$age<-c(0:19)
#bunkatu3$age<-bunkatu3$age*5
#bunkatu3<-subset(bunkatu3,bunkatu3$age>0)



getHazard<-function(parS,xx) (getPred(parS,xx)-getPred(parS,xx+1))/getPred(parS,xx)
residFun <- function(p, observed, xx) observed - getPred(p,xx)

kansu<-"weibull"
kansu<-"log-normal"
kansu<-"logistic"
kansu<-"log-logistic"
kansu<-"normal"
kansu<-"exp"

if (kansu=="weibull"){
  #ワイブル分布
  getPred <- function(parS, xx) parS$a * exp(- parS$lambda*xx^parS$k)
  parStart <- list(a=15,lambda=0.5, k=0.05)
} else if (kansu=="log-normal"){
  #対数正規分布
  getPred <- function(parS, xx) parS$a*(1-pnorm((log(xx)-parS$mu)/parS$sigma))
  parStart <- list(a=15,mu=10,sigma=5)
  
} else if (kansu=="logistic"){
  #logistic
  getPred <- function(parS, xx) parS$a*exp((-xx+parS$mu)/parS$sigma)/(1+exp((-xx+parS$mu)/parS$sigma))
  parStart <- list(a=15,mu=3,sigma=0.2)
} else if(kansu=="log-logistic"){
  getPred<-function(parS,xx) parS$a/(1+parS$lambda*xx^parS$k)
  parStart<-list(a=15,lambda=3,k=1)
} else if(kansu=="normal"){
  getPred<-function(parS, xx) parS$a*(1-pnorm((xx-parS$mu)/parS$sigma))
  parStart<-list(a=15,mu=1,sigma=1)
}else if(kansu=="exp"){
  getPred<-function(parS, xx) parS$a*exp(-parS$lambda*xx)
  parStart<-list(a=15,lambda=1)
}

nls.out <- nls.lm(par=parStart, fn = residFun, observed = bunkatu3$Freq,
                  xx = bunkatu3$age, control=nls.lm.control(maxiter=1024,nprint=1))


summary(nls.out)

#可視化
x_forplot <- data.frame(x=seq(0, 120, by=5))
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
outfile<-paste("mortality/betula0115",kansu,".txt")
sink(outfile)
print(getPred)
print(nls.out)
summary(nls.out)
sink()

