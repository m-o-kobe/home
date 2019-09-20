library(GGally)
library(ggplot2)
DFc<-read.csv("ds4_brand2018_b.csv")
DBcall<-subset(DFc,DFc$row=="全体")
PlotList <- list()
k=as.integer(0)
for(i in 11:12){
  for(j in 13:14){
    k=k+1
    PlotList[[k]]<-qplot(as.numeric(DBcall[-c(1),i]),as.numeric(DBcall[-c(1),j]))
    #plotList[[k]] <- ggally_text(paste("Plot #", k, sep = ""))
      }
}
class(k)
ggmatrix(PlotList,nrow=2,ncol=2)
g<-ggplot(DBcall,
     aes(x =B_x1, y =B_x2))+
  geom_point()
print(g)
plot(DBcall[10],DBcall[j])
     
q<-qplot(DBcall$year,DBcall$base)

class(DBcall$gyo2name)
DBcall[10]
class(as.numeric(DBcall[-c(1),10]))

##やり直したやつメモ代わり

library(GGally)
library(ggplot2)
"+" = function(e1, e2){
  if(is.character(c(e1, e2))){
    paste(e1, e2, sep="")
  }else{
    base::"+"(e1, e2)
  }
}
DFc<-read.csv("ds4_brand2018_b.csv")
DBcall<-subset(DFc,DFc$row=="全体")
par(mfrow=c(2,2)) 
PlotList<-list()
DF<-data.frame(b1 = numeric(0), b2 = numeric(0),col = numeric(0),cor=numeric(0),gyokai=numeric(0))
for(i in 9:17){
  for(j in 62:70){
    fordraw<-data.frame(b1=as.numeric(DBcall[,i]),b2=as.numeric(DBcall[,j]),col=colnames(DBcall[i])+"_"+colnames(DBcall[j]),gyokai=DBcall[,5])
    DF<-rbind(DF,fordraw)
    PlotList[[colnames(DBcall[i])+"_"+colnames(DBcall[j])]]<-cor(as.numeric(DBcall[,i]),as.numeric(DBcall[,j]))
  }
}
plot(PlotList)
class(k)
p <- ggplot(DF, aes(x=b1, y=b2,colour=PlotList[[col]]))+
  geom_point()+
  #  geom_text(label=PlotList[[col]], alpha=.1)+
  facet_wrap(~col,scales="free",ncol=9)
print(p)
cor(DF$b1,DF$b2)

ggmatrix(PlotList,nrow=2,ncol=2)
g<-ggplot(DBcall,
          aes(x =B_x1, y =B_x2))+
  geom_point()
print(g)
plot(DBcall[10],DBcall[j])

q<-qplot(DBcall$year,DBcall$base)

class(DBcall$gyo2name)
DBcall[10]
class(as.numeric(DBcall[-c(1),10]))