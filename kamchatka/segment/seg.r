tablecsv<-function(datalm,data,ou){
  sum<-summary(datalm)
  coe <- sum$coefficient
  psi<-sum$psi
  N <- nrow(data)
  aic <- AIC(datalm)
  result <- cbind(coe,aic,N)
  result[2:nrow(result),5:6] <- ""
  
  write.table(matrix(c("\n",colnames(result)),nrow=1),ou,append=T,quote=F,sep=","
              ,row.names=F,col.names=F)
  write.table(result,ou,append=T,quote=F,sep=",",row.names=T,col.names=F)
  write.table(matrix(c("\n",colnames(psi)),nrow=1),ou,append=T,quote=F,sep=","
              ,row.names=F,col.names=F)
  write.table(psi,ou,append=T,quote=F,sep=",",row.names=T,col.names=F)
}

int<-read.csv("ctrl0315.csv")
int2<-subset(int,(int$dbh01>0)&(int$hgt>0))
int3<-subset(int2,int2$spp=="bp")
int.lm<-lm(hgt~dbh01,data=int3)
int.seg<-segmented(int.lm,seg.Z=~dbh01)
plot(int3$dbh01,int3$hgt)
plot(int.seg,conf.level=0.95, shade=T,add=T)
tablecsv(int.seg,int3,"seg_ctr_bp.csv")
