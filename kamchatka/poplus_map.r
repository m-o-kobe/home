parent<-read.csv("fire2.csv", fileEncoding = "UTF-8-BOM")

xmax<-15
ymax<-17
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
