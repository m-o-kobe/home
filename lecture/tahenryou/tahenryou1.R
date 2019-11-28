data1<-read.table("ekman2.txt",header=TRUE)
coln<-colnames(data1)
data1<-as.matrix(data1)

data2<-matrix(as.numeric(0),nrow=14,ncol=14)
for(i in 1:14){
  for(j in 1:14){
    if(i==j){
      data2[i,j]<-as.numeric(0.0)
      }else if(data1[i,j+1]=="."){
        data2[i,j]<-4.0-as.numeric(data1[j,i+1])
      }else{
        data2[i,j]<-4.0-as.numeric(data1[i,j+1])
      }
  }
}

data2<-as.data.frame(data2)
colnames(data2)<-coln[2:15]
result<-cmdscale(data2,k=2,eig=T)
loc1<-result$points[,1]
loc2<-result$points[,2]+0.3
loc_name<-cbind(loc1,loc2)

plot(result$points,col="black",xlim=c(-2,2),ylim=c(-2,2),asp = 1)
text(loc_name,names(data2),col="red",font=2)
