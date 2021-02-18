library(ggplot2)
library(scales)
ver="saishu"

freq1=c(40,50,60,70,80,90,100,110,120,130,140,150,200,250)
flen=length(freq1)
hyou<-data.frame(Larix_cajanderi=1,Betula_platyphylla=1,Populus_tremula=1,lcnum=1,bpnum=1,ptnum=1,freq=1)  
for (j in 1:flen){
  freq<-freq1[j]
  title=paste("fire",freq,sep="")
  filename=paste("output/",ver,"/output0129ctr_",title,".csv",sep="")
  data=read.csv(filename,header=FALSE)
  names(data)<-c("year","x","y","sp","age","size","tag","mother","crd","kabu","sprout")
  data$ba<-data$size^2*pi/40000
  maxy<-max(data$year)
  kaisu<-maxy/freq
  print(maxy)
  data$sp[data$sp==1]<-"Larix_cajanderi"
  data$sp[data$sp==2]<-"Betula_platyphylla"
  data$sp[data$sp==3]<-"Populus_tremula"
  data$sp<-as.factor(data$sp)
  data<-subset(data,data$size>0.000001)
  for (i in 1:kaisu) {
    #i=1
    
    year1=i*freq
    data1=subset(data,data$year==year1)
    
    lc<-subset(data1,data1$sp=="Larix_cajanderi")
    bp<-subset(data1,data1$sp=="Betula_platyphylla")
    pt<-subset(data1,data1$sp=="Populus_tremula")
    lcba<-sum(lc$ba)
    lcnum<-nrow(lc)
    bpba<-sum(bp$ba)
    bpnum<-nrow(bp)
    ptba<-sum(pt$ba)
    ptnum<-nrow(pt)
    
    df<-c(lcba,bpba,ptba,lcnum,bpnum,ptnum,freq)
    hyou<-rbind(hyou,df)
    
  }
}

hyou$ba<-hyou$Larix_cajanderi+hyou$Betula_platyphylla+hyou$Populus_tremula
hyou$Lc<-hyou$Larix_cajanderi/hyou$ba
hyou$Bp<-hyou$Betula_platyphylla/hyou$ba
hyou$Pt<-hyou$Populus_tremula/hyou$ba
hyou$kotai<-hyou$lcnum+hyou$bpnum+hyou$ptnum
hyou$lchi<-hyou$lcnum/hyou$kotai
hyou$bphi<-hyou$bpnum/hyou$kotai
hyou$pthi<-hyou$ptnum/hyou$kotai

hyou1<-hyou[-1,]
hyou2<-data.frame(freq=1,ba_ratio=1,num=1,num_ratio=1,spp=1,ba=1)
#hyou2<-as.matrix(hyou2)
hyoulen<-nrow(hyou1)



for (i in 1:hyoulen){
  memo<-hyou1[i,]
  memo1<-c(memo$freq,memo$Lc,memo$lcnum,memo$lchi,"Larix_cajanderi",memo$ba)
  hyou2<-rbind(hyou2,memo1)
  memo1<-c(memo$freq,memo$Bp,memo$bpnum,memo$bphi,"Betula_platyphylla",memo$ba)
  hyou2<-rbind(hyou2,memo1)
  memo1<-c(memo$freq,memo$Pt,memo$ptnum,memo$pthi,"Populus_tremula",memo$ba)
  hyou2<-rbind(hyou2,memo1)
}
hyou3<-hyou2[-1,]
hyou3$freq<-as.integer(hyou3$freq)
hyou3$ba_ratio<-as.double(hyou3$ba_ratio)
hyou3$ba<-as.double(hyou3$ba)
hyou3$spp<-as.factor(hyou3$spp)
hyou3$num<-as.integer(hyou3$num)
hyou3$num_ratio<-as.double(hyou3$num_ratio)


#ctr<-read.csv("ctrl0315.csv")
#ctr<-read.csv("int0313.csv")

ctr1<-subset(ctr,ctr$dbh01>0.0)
ctr1$ba<-pi*ctr1$dbh01^2/40000
ctr1lc<-subset(ctr1,ctr1$spp=="lc")
ctr1bp<-subset(ctr1,ctr1$spp=="bp")
ctr1pt<-subset(ctr1,ctr1$spp=="pt")
numlc<-nrow(ctr1lc)/nrow(ctr1)
numbp<-nrow(ctr1bp)/nrow(ctr1)
numpt<-nrow(ctr1pt)/nrow(ctr1)
balc<-sum(ctr1lc$ba)/sum(ctr1$ba)
babp<-sum(ctr1bp$ba)/sum(ctr1$ba)
bapt<-sum(ctr1pt$ba)/sum(ctr1$ba)
ctrba<-c(balc,babp,bapt)
ctrnum<-c(numlc,numbp,numpt)
ctrjushu<-c("Larix_cajanderi","Betula_platyphylla","Populus_tremula")
ctr2<-cbind(ctrba,ctrnum,ctrjushu)
#ctrc<-as.data.frame(ctr2)
#ctrc$yr<-200
#ctri<-as.data.frame(ctr2)
#ctri$yr<-40
ctr3<-rbind(ctri,ctrc)
ctr3$ctrba<-as.double(as.character(ctr3$ctrba))
ctr3$ctrnum<-as.double(as.character(ctr3$ctrnum))
ctr4<-subset(ctr3,ctr3$yr==200)

#write.csv(hyou3,"kekka0214.csv")

hyou4<-hyou3
hyou4$freq<-as.factor(hyou4$freq)
l<-ggplot( hyou4, aes( x = freq, y = ba_ratio,fill=spp ) ) +
  geom_bar( stat = "summary", fun = "mean" ) +theme_bw() +
  #stat_summary(fun = "mean", geom = "point", shape = 21, size = 2.) +
 # stat_summary( fun.data = "mean_se", geom = "errorbar", width = .2)+
  ylim(0.0,1.01)
print(l)
#横線引くバージョン
l<-ggplot( hyou3, aes( x = freq, y = ba_ratio,colour=spp ) ) +
  geom_line( stat = "summary", fun = "mean" ) +theme_bw() +
  stat_summary(fun = "mean", geom = "point", shape = 21, size = 2., fill = "black") +
  stat_summary( fun.data = "mean_se", geom = "errorbar", width = .2)+ylim(0.0,1.0)+
  geom_hline(aes(yintercept=babp),color=hue_pal()(3)[1],linetype="dashed",size=1)+
  geom_hline(aes(yintercept=balc),color=hue_pal()(3)[2],linetype="dashed",size=1)+
  geom_hline(aes(yintercept=bapt),color=hue_pal()(3)[3],linetype="dashed",size=1)

#ひし形のバージョン
l<-ggplot( hyou3, aes( x = freq, y = ba_ratio,colour=spp ) ) +
  geom_line( stat = "summary", fun = "mean" ) +theme_bw() +
  stat_summary(fun = "mean", geom = "point", shape = 21, size = 2., fill = "black") +
  stat_summary( fun.data = "mean_se", geom = "errorbar", width = .2)+ylim(0.0,1.0)+
  geom_point(data=ctr4,aes(x=yr,y=ctrba,colour=ctrjushu), 
             stat="identity",
             position="identity",shape=18,
              size=4) 
plot( l )


#ひし形のバージョン
l<-ggplot( hyou3, aes( x = freq, y = num_ratio,colour=spp ) ) +
  geom_line( stat = "summary", fun = "mean" ) +theme_bw() +
  stat_summary(fun = "mean", geom = "point", shape = 21, size = 2., fill = "black") +
  stat_summary( fun.data = "mean_se", geom = "errorbar", width = .2)+ylim(0.0,1.0)+
  geom_point(data=ctr4,aes(x=yr,y=ctrnum,colour=ctrjushu), 
             stat="identity",
             position="identity",shape=18,
             size=4) 
plot( l )


l <- ggplot( hyou3, aes( x = freq, y = num_ratio,colour=spp ) ) +
  geom_line( stat = "summary", fun = "mean" ) +theme_bw() +
  stat_summary(fun = "mean", geom = "point", shape = 21, size = 2., fill = "black") +
  stat_summary( fun.data = "mean_se", geom = "errorbar", width = .2)+ylim(0.0,1.0)+
  geom_hline(aes(yintercept=numbp),color=hue_pal()(3)[1],linetype="dashed",size=1)+
  geom_hline(aes(yintercept=numlc),color=hue_pal()(3)[2],linetype="dashed",size=1)+
  geom_hline(aes(yintercept=numpt),color=hue_pal()(3)[3],linetype="dashed",size=1)
#xlab( "月" ) +
#ylab( "気温（華氏）" ) +
#scale_y_continuous( breaks = c( 32, 52, 72, 92 ), limits = c( 32, 95 ) ) 
plot( l )

l <- ggplot( hyou3, aes( x = freq, y = num,colour=spp ) ) +
  geom_line( stat = "summary", fun = "mean" ) +theme_bw() +
  stat_summary(fun = "mean", geom = "point", shape = 21, size = 2., fill = "black") +
  stat_summary( fun.data = "mean_se", geom = "errorbar", width = .2) #+
#xlab( "月" ) +
#ylab( "気温（華氏）" ) +
#scale_y_continuous( breaks = c( 32, 52, 72, 92 ), limits = c( 32, 95 ) ) 
plot( l )

l<-ggplot(hyou1,aes(x=freq,y=kotai))+geom_line( stat = "summary", fun = "mean" ) +theme_bw() +
  stat_summary(fun = "mean", geom = "point", shape = 21, size = 2., fill = "black") +
  stat_summary( fun.data = "mean_se", geom = "errorbar", width = .2) #+
plot(l)
