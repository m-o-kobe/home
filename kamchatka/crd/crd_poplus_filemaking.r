df=read.csv("int0313.csv")
summary(df)

xmax<-9
#ymax<-9
#ymin=-10
#↑intの場合
#↓ctrの場合
xmax<-19
ymax<-9
ymin<-0
parent1<-data.frame(x=1000,y=1000)
for(i in 0:xmax){
  xi<-i*5.0
  for(j in ymin:ymax){
    yj<-j*5.0
    parent2<-c(xi,yj)
    parent1<-rbind(parent1,parent2)
  }
}
parent1<-subset(parent1,parent1$x!=1000)
#
#write.csv(parent1,"crd/map_int.csv",row.names = FALSE)
#write.csv(parent1,"crd/map_ctr.csv",row.names = TRUE)


#↓fire
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
#
write.csv(parent1,"crd/map.csv")


