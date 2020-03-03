args <- commandArgs(trailingOnly=T)
file1 <-args[1]
file2 <-args[2]
out <-args[3]
buf1<-read.csv(file1, header=T)
buf2<-read.csv(file2, header=T)
data<-rbind(buf1,buf2)
data1.lm<-lm(formula = growth ~ dbh01 + crd1 + crd2 + crd3 + crd4 + crd5 + crd6 + crd7 + crd8 + crd9 + kabudachi, data = data)
#data2.step<-step(data1.lm)
data1sum<-summary(data1.lm)

