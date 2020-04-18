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



datalm<-model3
data<-fire2

library(MuMIn)
options(na.action = "na.fail")

motofire<-read.csv("fire_maiboku0302.csv")




fire00<-subset(motofire,motofire$D.A..2000.=="A")
fire02<-subset(motofire,motofire$X.A......2002.=="A")
fire00$da<-0
fire00$da[fire00$X.A......2002.=="A"]<-1
fire02$da<-0
fire02$da[fire02$D.A......2004.=="A"]<-1
sp="La"
fire1<-rbind(fire00,fire02)
fire2<-subset(fire1,fire1$sp.==sp)

model1<-glm(formula=da~dbh0+fire,data=fire2)
model2<-glm(formula=da~dbh0+fire+0,data=fire2)

summary(model1)
summary(model2)

model_hikaku1<-dredge(model1,rank="BIC")
model_hikaku2<-dredge(model2,rank="BIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)

model3<-glm(formula=da~dbh0+fire+0,data=fire2)
summary(model3)
#outcsv<-paste("mortality/after_fire_mortality",sp,"0408.csv",sep="_")
#write.csv(model_hikaku,outcsv)
#tablecsv(model3,fire2,outcsv)


####ruby用ファイル作成
fire3<-motofire[,c(4,24,25,5,26,27,28,14)]
fire3$sprout..old.<-as.character(fire3$sprout..old.)
fire3$sprout..old.[fire3$sprout..old.==""]<-0
colnames(fire3)[1]<-"#number"
fire3$sprout..old.<-gsub(",","_",fire3$sprout..old.)
fire3$sprout..old.<-gsub("'","_",fire3$sprout..old.)

#num	x	y	spp	dbh01	dbh04	hgt	sprout
#↓コメントアウト部分を実行
#write.csv(fire3,"crd/fire0410.csv",row.names = FALSE)


fire4<-subset(fire3,fire3$da==1)
#↓コメントアウト部分を実行
#write.csv(fire4,"crd/fire_survival0410.csv",row.names = FALSE)


###crdも入れた解析
fire_crd<-read.csv("crd/crd_fire_sv_200409.csv")
colnames(fire_crd)
colnames(fire_crd)[5:7]<-c("dbh00","da","fire")
colnames(fire_crd)[1]<-"number"


fire_crd1<-merge(fire2,fire_crd,by="number")

model1<-glm(formula=da.x~dbh0+fire.x+Crd2+Crd3+Crd4+Crd5+Crd6+Crd7+Crd8+Crd9,data=fire_crd1)
model2<-glm(formula=da.x~dbh0+fire.x+Crd2+Crd3+Crd4+Crd5+Crd6+Crd7+Crd8+Crd9+0,data=fire_crd1)

summary(model1)
summary(model2)

model_hikaku1<-dredge(model1,rank="BIC")
model_hikaku2<-dredge(model2,rank="BIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)
best<-model_hikaku[1]
#Be
#model3<-glm(formula=da.x~dbh0+fire.x+Crd9,data=fire_crd1)
#La
#model3<-glm(formula=da.x~fire.x,data=fire_crd1)

summary(model3)
#outcsv<-paste("mortality/after_fire_mortality",sp,"0410.csv",sep="_")
#write.csv(model_hikaku,outcsv)
#tablecsv(model3,fire_crd1,outcsv)
