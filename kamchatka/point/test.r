library(ggplot2)
library(spatstat)

moto<-read.csv("int0313.csv")
int1<-moto

sp<-"lc"
int2<-subset(int1,int1$spp==sp)

parent<-subset(int2,int2$dbh01>2.1)
child<-subset(int2,int2$dbh01<=2.1)

pppdata_p<-ppp(x=parent$x,y=parent$y,window=owin(c(0,50),c(-50,50)),marks=parent$dbh01)
pppdata_c<-ppp(x=child$x,y=child$y,window=owin(c(0,50),c(-50,50)),marks=child$dbh01)



thomas_p<-thomas.estK(pppdata_p)
thomas_c<-thomas.estK(pppdata_c)

plot(thomas_p,sqrt(./pi)-r~r)
plot(thomas_c,sqrt(./pi)-r~r)

#thomas_graph<-thomas_1$fit
par_p<-thomas_p$modelpar
par_c<-thomas_c$modelpar


fitted_r_p<-thomas_p$fit$r



for (i in 1:80) {
  tho_r_p<-rThomas(kappa=par_p[1],scale=par_p[2]^2,mu=par_p[3],win=owin(c(0,50),c(-50,50)))
  t_r_p<-thomas.estK(tho_r_p)
  fitted_r_p<-cbind(fitted_r_p,t_r_p$fit$fit)
}
fitted_p<-fitted_r_p[,2:81]
sortlist<-fitted_r_p<-thomas_p$fit$r

sortlist<-fitted_p[1,]
for(i in 2:513) {
  sortlist<-rbind(sortlist,
                  fitted_p[i,order(fitted_p[i,])])
}


fitted_p[1,order(fitted_p[1,])]
hi_low<-cbind(thomas_p$fit$r,sortlist[,2],"low")
hi_low<-rbind(hi_low,cbind(thomas_p$fit$r,sortlist[,79],"hi"))
hi_low<-rbind(hi_low,cbind(thomas_p$fit$r,thomas_p$fit$fit,"observed"))

hi_low<-as.data.frame(hi_low)
names(hi_low)<-c("r","k","label")
hi_low$r<-as.double(as.character(hi_low$r))
hi_low$k<-as.double(as.character(hi_low$k))

hi_low$k_hosei<-sqrt(hi_low$k/pi)-hi_low$r

g1<-ggplot(data=hi_low,
           aes(x=r,y=k_hosei,colour=label))+
  geom_line()

print(g1)

plot(hi_low$r,hi_low$low_hosei,type = "l")
par(new=T)
plot(hi_low$r,hi_low$hi_hosei,type="l")

length(fitted_p[2,order(fitted_p[2,])])
plot(thomas.estK(tho_r_p),sqrt(./pi)-r~r)


thomas_1
plot(thomas_1)

#test<-clusterradius("Thomas",scale=1)
#test<-clusterkernel("Thomas",scale=1)

test

result_thomas<-envelope(pppdata,fun=thomas.estpcf$fit,nsim=80,nrank=2,normalise=FALSE,kernel="epanechnikov")
test<-envelope(pppdata,fun=thomas_henkei,nsim=80,nrank=2,
               startpar=c(kappa=0.01885377,
               scale=0.005688834),
               lambda=0.1138
               )

#envelope(ppdata1,fun=pcf,nsim=80,nrank=2,normalise=FALSE,kernel="epanechnikov")

par<-thomas_1$modelpar
thomas_result<-rThomas(kappa=par[1],scale=par[2]^2,mu=par[3],win = owin(c(0,50),c(-50,50)),nsim=80,nrank=2)
thomas_result

#D=Aかどうかを基準としたmarkcor
ms<-envelope(pppdata,fun=markcorr,f=function(m1,m2){m1==m2},nsim=80,nrank=2,normalise=FALSE,kernel="epanechnikov")
ms<-envelope(pppdata,fun=markcrosscorr,f=function(m1,m2){m1==m2},i=="A",j!="A",nsim=80,nrank=2,normalise=FALSE,kernel="epanechnikov")

ms<-envelope(pppdata,fun=markcorr,f=function(m1,m2){m1==m2},nsim=1000,nrank=25,normalise=FALSE,kernel="epanechnikov")



#k100<-envelope(pppdata,fun=Lest,correction="Ripley",nsim=80,nrank=2)
#plot(k100,.-r~r,main=sp, xlim=c(0,13))

#K<-envelope(pppdata,fun=Kmulti,marks(pppdata) =="A", marks(pppdata) != "A",nsim=80,nrank=2)
#作図
#plot(K,sqrt(./pi)-r~r,main=sp)

plot(ms,main="m1==m2")

valuek<-fvnames(ms,a=".")
k100as<-as.function(ms,value=valuek)

kmatome<-data.frame(r=seq(0,20,0.1))

kmatome$theo<-k100as(kmatome$r,"theo")
kmatome$obs<-k100as(kmatome$r,"obs")
kmatome$hi<-k100as(kmatome$r,"hi")
kmatome$lo<-k100as(kmatome$r,"lo")

write.csv(kmatome,"firem1==m2.csv")




thomas_henkei<-function (X, startpar = c(kappa = 1, scale = 1), lambda = NULL, 
          q = 1/4, p = 2, rmin = NULL, rmax = NULL, ..., pcfargs = list()) 
{
  dataname <- getdataname(short.deparse(substitute(X), 20), 
                          ...)
  if (inherits(X, "fv")) {
    g <- X
    if (!identical(attr(g, "fname")[1], "g")) 
      warning("Argument X does not appear to be a pair correlation function")
  }
  else if (inherits(X, "ppp")) {
    g <- do.call(pcf.ppp, append(list(X), pcfargs))
    dataname <- paste("pcf(", dataname, ")", 
                      sep = "")
    if (is.null(lambda)) 
      lambda <- summary(X)$intensity
  }
  else stop("Unrecognised format for argument X")
  info <- spatstatClusterModelInfo("Thomas")
  startpar <- info$checkpar(startpar)
  theoret <- info$pcf
  argu <- fvnames(g, ".x")
  rvals <- g[[argu]]
  if (rvals[1] == 0 && (is.null(rmin) || rmin == 0)) {
    rmin <- rvals[2]
  }
  result <- mincontrast(g, theoret, startpar, ctrl = list(q = q, 
                                                          p = p, rmin = rmin, rmax = rmax), fvlab = list(label = "%s[fit](r)", 
                                                                                                         desc = "minimum contrast fit of Thomas process"), 
                        explain = list(dataname = dataname, fname = attr(g, "fname"), 
                                       modelname = "Thomas process"), ...)
  par <- result$par
  names(par) <- c("kappa", "sigma2")
  result$par <- par
  result$modelpar <- info$interpret(par, lambda)
  result$internal <- list(model = "Thomas")
  result$clustpar <- info$checkpar(par, old = FALSE)
  #return(result)
  return(g)
}
