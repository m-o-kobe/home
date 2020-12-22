data<-read.csv("fire_layer.csv",header = FALSE)
start<-1

data1<-data[ 1:50,]
data2<-data[ 41:90,]
data1<-t(data1)
data2<-t(data2)

write.csv(data1,"setting/fire_layer1to50.csv")
write.csv(data2,"setting/fire_layer41to90.csv")

int_data<-read.csv("int0313.csv")

int_data$age<-1
int_out<-cbind(int_data$x,int_data$y,int_data$spp,int_data$age,int_data$dbh01,int_data$X.num,int_data$sprout)
write.csv(int_out,"init_int1216.csv",row.names = FALSE)


ctrl_data<-read.csv("ctrl0315.csv")
levels(ctrl_data$spp)

levels(ctrl_data$spp)<-c("af","2","1","3","sb","sorbus comixta","sorbus comixta")
ctrl_data<-subset(ctrl_data,ctrl_data$spp!="af")
ctrl_data<-subset(ctrl_data,ctrl_data$spp!="sb")
ctrl_data<-subset(ctrl_data,ctrl_data$spp!="sorbus comixta")

ctrl_data$age<-1
ctrl_data<-subset(ctrl_data,ctrl_data$x>0.0 )
ctrl_data<-subset(ctrl_data,ctrl_data$x<100.0 )
ctrl_data<-subset(ctrl_data,ctrl_data$y>0.0 )
ctrl_data<-subset(ctrl_data,ctrl_data$y<50.0 )



ctrl_out<-ctrl_data[,c(2,3,4,9,5,1,8)]
#ctrl_out<-cbind(ctrl_data$x,ctrl_data$y,ctrl_data$spp,ctrl_data$age,ctrl_data$dbh01,ctrl_data$X.num,ctrl_data$sprout)
colnames(ctrl_out)[1]<-"#x"




write.csv(ctrl_out,"setting/init_ctr1216.csv",row.names = FALSE,col.names = FALSE)

summary(ctrl_out)
