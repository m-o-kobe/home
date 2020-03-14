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
    result[2:nrow(result),5:8] <- ""
  }
  
  write.table(matrix(c("\n",colnames(result)),nrow=1),ou,append=T,quote=F,sep=","
              ,row.names=F,col.names=F)
  write.table(result,ou,append=T,quote=F,sep=",",row.names=T,col.names=F)
}


parent<-read.csv("fire2.csv", fileEncoding = "UTF-8-BOM")


fire1<-subset(parent,parent$sp.=="Po")
fire1$xx<-as.numeric(fire1$grid..x.)+as.numeric(as.character(fire1$x))
fire1$yy<-as.numeric(fire1$grid..y.)+as.numeric(as.character(fire1$y))
fire1$DBH00cm[is.na(fire1$DBH00cm)]<-0
fire1$GBH00cmn[is.na(fire1$GBH00cmn)]<-0
fire1$dbh00<-as.numeric(fire1$DBH00cm)+as.numeric(fire1$GBH00cmn)/acos(-1)
poplus<-fire1[,c(7,8,4,27)]
poplus$x1<-0
poplus$x2<-0
poplus$x3<-0

#write.csv(poplus,"fire_poplus.csv")

children<-read.csv("5m_poplus_datateisei.csv",fileEncoding = "UTF-8-BOM")
parent<-read.csv("crd/poplus_map.csv")

#parent$firex<-as.integer(((parent$x+2.5)/xstep)+1)
#parent$firey<-as.integer(((parent$y+2.5)/ystep)+1)

#fire4<-subset(parent,f(firex,firey))
fire4<-parent
fire4$fire<-0
intensity2<-intensity1$v
len<-nrow(fire4)
for(i in 1:len){
  fire_intensity<-intensity2[fire4$y[i]+3,fire4$x[i]+3]
  print(i)
  fire4$fire[i]<-as.numeric(fire_intensity)
}

parent<-fire4

taiou<-merge(parent,children)
sum41<-taiou[,c(3,4,5,6,8,18)]
name1<-colnames(sum41)
plotList <- list()
k=1
for (i in 1:5){
  for (j in 6:8){
    xmax<-max(sum41[i])
    ymax<-max(sum41[j])
    plotList[[k]]<-ggplot(data=sum41,aes_string(x=name1[i],y=name1[j]))+
      geom_point()+
      geom_text(x=xmax/2,
                y=ymax/2,
                label=as.character(round(cor(sum41[i],sum41[j],method ="spearman"),digits=4)),alpha=0.5,color="blue")
    #ggally_text(as.character(cor(sum41[i],sum41[j],method ="spearman")))
    k<-k+1
  }
}


pm<-ggmatrix(plotList,
             nrow=3,ncol=5,
             xAxisLabels = name1[1:5],
             yAxisLabels=name1[6:8],
             byrow = FALSE)
print(pm)

library(GGally)
p<-ggpairs(data=sum41)
print(p)
po_lm<-lm(formula=Po_sucker2000~Crd5*Crd10*Crd15*crd20-1,data=sum41)
po_lm<-lm(formula=Po_sucker2000~Crd5+Crd10+Crd15+crd20-1,data=sum41)

library(MuMIn)
options(na.action = "na.fail")
model_5<-dredge(po_lm,rank="BIC")
best.model <- get.models(model_5, subset = 1)[1]
best.model_<-best.model$`16`
model_6<-lm(best.model_$call,data=sum41)
summary(model_6)

#tablecsv(model_6,bp_sum,"bp_fire_kabugoto0226.csv")



summary(po_lm)
po_lm1<-step(po_lm,k=log(nrow(sum41)))
summary(po_lm1)
sp="po"
outcsv<-paste("kousin_plot",sp,"0225.csv",sep="_")

tablecsv(po_lm,sum41,outcsv)
tablecsv(po_lm1,sum41,outcsv)



par(mfrow=c(2,2)) 
plot(po_lm1)

par(mfrow=c(1,1))

plot(model_6$fitted.values,sum41$Po_sucker2000)
sum(model_6$fitted.values)

summary(po_lm1$fitted.values)

sum(sum41$Po_sucker2000)
