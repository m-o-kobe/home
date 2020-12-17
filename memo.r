data<-read.csv("fire_layer.csv",header = FALSE)
start<-1

data1<-data[ 1:50,]
data2<-data[ 41:90,]
write.csv(data1,"fire_layer1to50.csv")
write.csv(data2,"fire_layer41to90.csv")

int_data<-read.csv("int0313.csv")
ctrl_data<-read.csv("ctrl0315.csv")

int_data$age<-1
int_out<-cbind(int_data$x,int_data$y,int_data$spp,int_data$age,int_data$dbh01,int_data$X.num,int_data$sprout)
write.csv(int_out,"init_int1216.csv",row.names = FALSE)


ctrl_