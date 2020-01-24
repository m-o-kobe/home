parent<-read.csv("fire2.csv", fileEncoding = "UTF-8-BOM")

xmax<-17
ymax<-19
parent1<-data.frame(x=1000,y=1000)
for(i in 0:xmax){
  xi<-i*5
  for(j in 0:ymax){
    yj<-j*5
    parent2<-c(xi,yj)
    parent1<-rbind(parent1,parent2)
  }
}
parent1<-subset(parent1,parent1$x!=1000)
write.csv(parent1,"map.csv")

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

write.csv(poplus,"fire_poplus.csv")

children<-read.csv("5m_poplus_datateisei.csv",fileEncoding = "UTF-8-BOM")
parent<-read.csv("crd/poplus_map.csv")
taiou<-merge(parent,children)
sum41<-taiou[,c(3,4,5,6,7,8,10,17)]
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
po_lm<-lm(formula=Po_sucker2000~Crd5+Crd10+Crd15+crd20,data=sum41)
summary(po_lm)
par(mfrow=c(2,2)) 
plot(po_lm)
