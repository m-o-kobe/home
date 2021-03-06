library(doBy)
library(dplyr)
library(ggplot2)
library(GGally)
out<-"../../../kaiki.csv"
tablecsv<-function(datalm,data,ou){
    sum<-summary(datalm)
    coe <- sum$coefficient
    N <- nrow(data)
    aic <- AIC(datalm)
    result <- cbind(coe,aic,N)
    result[2:nrow(result),5:6] <- ""
    
    write.table(matrix(c("\n",colnames(result)),nrow=1),ou,append=T,quote=F,sep=","
    ,row.names=F,col.names=F)
    write.table(result,ou,append=T,quote=F,sep=",",row.names=T,col.names=F)
}

DF <- read.csv("../../../marinair-pref.csv", header = TRUE, stringsAsFactors = FALSE)
pop<- read.csv("../../../pop_dis.csv", header = TRUE, stringsAsFactors = FALSE)
pop$kinki<-0
pop$flight<-0
pop[24:30,]$kinki<-1

pop[pop$Prefecturecode==1,]$flight<-399777
pop[pop$Prefecturecode==4,]$flight<-154769
pop[pop$Prefecturecode==8,]$flight<-156537
pop[pop$Prefecturecode==13,]$flight<-849615
pop[pop$Prefecturecode==42,]$flight<-219194
pop[pop$Prefecturecode==46,]$flight<-151524
pop[pop$Prefecturecode==47,]$flight<-427342
jinryu<-summaryBy(jinryu~Prefecturecode,data=DF,FUN=c(mean,length))
jinryu$jinryu<-jinryu$jinryu.mean*jinryu$jinryu.length

matome<-inner_join(pop,jinryu)


lmresult<-lm(jinryu~Population+kinki+flight+distance,data=matome)
tablecsv(lmresult,matome,out)
slm<-step(lmresult)
tablecsv(slm,matome,out)

matome$distance_1<-1/matome$distance
matome$distance_2<-1/(matome$distance)^2


lmresult<-lm(jinryu~Population+flight+distance_1+Population*flight+distance_1*flight+Population*distance_1,data=matome)
tablecsv(lmresult,matome,out)
slm<-step(lmresult)

tablecsv(slm,matome,out)
lmresult<-lm(jinryu~Population+flight+distance_2+Population*flight+distance_2*flight+Population*distance_2,data=matome)
tablecsv(lmresult,matome,out)
slm<-step(lmresult)
summary(slm)
tablecsv(slm,matome,out)
sum<-summary(slm)
coe <- sum$coefficient
matome$yosoku<-coe[1]+matome$Population*coe[2]+matome$flight*coe[3]+matome$distance_2*coe[4]+matome$Population*matome$distance_2*coe[5]
print(matome)
g<-ggplot(data=matome,aes(x=yosoku,y=jinryu,colour=as.character(kinki)))+
coord_fixed(ratio = 1)+
geom_point()
#geom_bar(stat="identity",position="fill")
png("../../../yosoku.png",height=960, width=960, res=144)
print(g)
dev.off()
#png("../../../kaikisindan.png",height=960, width=960, res=144)
#par(mfrow=c(2,2))
#plot(slm)
#dev.off()
