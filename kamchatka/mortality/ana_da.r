tablecsv<-function(datalm,data,ou){
    sum<-summary(datalm)
    coe <- sum$coefficient
    N <- nrow(data)
    aic <- AIC(datalm)
    result <- cbind(coe,aic,N)
    if (nrow(result)>2){
        result[2:nrow(result),5:6] <- ""
    }
    write.table(matrix(c("\n",colnames(result)),nrow=1),ou,append=T,quote=F,sep=","
    ,row.names=F,col.names=F)
    write.table(result,ou,append=T,quote=F,sep=",",row.names=T,col.names=F)
}

library(MuMIn)
options(na.action = "na.fail")

file1 <-read.csv("crd/crd_int_191209.csv")
file2 <-read.csv("crd/crd_ctr_200604.csv")
file3<-read.csv("fire_maiboku0302.csv")
sp<-"bp"
sp2<-"Be"
buf1<-subset(file1,file1$spp==sp)
buf2<-subset(file2,file2$spp==sp)
buf3<-subset(file3,file3$sp.==sp2)


buf1$death<-1
buf1$death[buf1$dbh04<0.0001]<-0
buf2$death<-1
buf2$death[buf2$dbh04<0.0001]<-0
buf1<-subset(buf1,buf1$dbh01>0.0001)
buf2<-subset(buf2,buf2$dbh01>0.0001)

data<-rbind(buf1,buf2)
#data1.glm<-glm(formula = death ~ dbh01 + Crd1 + Crd2 + Crd3 + Crd4 + Crd5 + Crd6 + Crd7 + Crd8 + Crd9 + sc,family=binomial, data = data)
#data2.step<-step(data1.glm)
#data1.glm<-glm(formula = death ~ dbh01 + crd+ sc,family=binomial, data = data)
#data2.glm<-glm(formula = death ~ dbh01 + crd+ sc+0,family=binomial, data = data)
#data1.glm<-glm(formula = death ~ dbh01 +I(dbh01^2)+ crd,family=binomial, data = data)
#data2.glm<-glm(formula = death ~ dbh01+I(dbh01^2) + crd+0,family=binomial, data = data)

#data1.glm<-glm(formula = death ~ dbh01 +I(dbh01^2)+ crd+sc,family=binomial, data = data)
#data2.glm<-glm(formula = death ~ dbh01+I(dbh01^2) + crd+sc+0,family=binomial, data = data)



summary(data1.glm)
summary(data2.glm)





model_hikaku1<-dredge(data1.glm,rank="AIC")
model_hikaku2<-dredge(data2.glm,rank="AIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)
#data3.glm<-glm(formula=death~crd+0,data=data,family=binomial)
#data3.glm<-step(data1.glm)
#data3.glm<-glm(formula=death~dbh01+0,data=data,family=binomial)
#data3.glm<-glm(formula=death~crd+0,family=binomial, data=data)


summary(data3.glm)


#outcsv<-paste("mortality/heiwa_mortality",sp,"1006.csv",sep="_")
#write.csv(model_hikaku,outcsv)

#lcのとき
#tablecsv(data1.glm,data,outcsv)
#tablecsv(data3.glm,data,outcsv)




