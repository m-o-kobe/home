#bp解析用
library(doBy)
library("stringr")
motofire<-read.csv("fire_maiboku.csv", fileEncoding = "UTF-8-BOM")
fire_sprout1<-read.csv("fire_bp_sprout.csv", fileEncoding = "UTF-8-BOM")
fire1<-motofire
#fire1$xx<-as.numeric(fire1$grid..x.)+as.numeric(as.character(fire1$x))
#fire1$yy<-as.numeric(fire1$grid..y.)+as.numeric(as.character(fire1$y))
fire1$DBH00cm[is.na(fire1$DBH00cm)]<-0
fire1$GBH00cmn[is.na(fire1$GBH00cmn)]<-0
fire1$dbh0<-as.numeric(fire1$DBH00cm)+as.numeric(fire1$GBH00cmn)/acos(-1)
fire1$da<-0
fire1$da[fire1$D.A..2000.=="A"]<-1


parent_bp<-subset(fire1,fire1$sp.=="Be")
parent_bp$color<-"0"
parent_bp$color[str_sub(parent_bp$number,start=1,end=1)=="B"]<-"b"
parent_bp$color[str_sub(parent_bp$number,start=1,end=1)=="b"]<-"b"
parent_bp$color[str_sub(parent_bp$number,start=1,end=1)=="Y"]<-"y"
parent_bp$color[str_sub(parent_bp$number,start=1,end=1)=="y"]<-"y"
parent_bp$num<-as.character(parent_bp$number)
parent_bp$num[parent_bp$color=="b"]<-str_sub(parent_bp$number[parent_bp$color=="b"],start=2)
parent_bp$num[parent_bp$color=="y"]<-str_sub(parent_bp$number[parent_bp$color=="y"],start=2)


parent_bp$sprout..old.<-as.character(parent_bp$sprout..old.)
parent_bp$sprout..old.[is.na(parent_bp$sprout..old)]<-as.character(parent_bp$num)[is.na(parent_bp$sprout..old)]
parent_bp$sprout..old.[parent_bp$sprout..old==""]<-as.character(parent_bp$num)[parent_bp$sprout..old==""]
parent_bp<-subset(parent_bp,parent_bp$color!="y")
parent_bp$color<-"b"
parent_bp$ba<-pi*parent_bp$dbh0^2
parent_bp$survival_ba<-parent_bp$ba*parent_bp$da



juvenile1<-fire_sprout1
juvenile1$parent_num1<-as.character(fire_sprout1$parent_num)
juvenile1$parent_color<-"b"
juvenile1$juvenile_ba<-pi*juvenile1$X04DBHmm^2
#as.character(juvenile1$parent_num1)
len1<-nrow(juvenile1)
len2<-nrow(parent_bp)
for(i in 1:len1){
  for(j in 1:len2){
    if((juvenile1$parent_color[i]==parent_bp$color[j])&(juvenile1$parent_num[i]==parent_bp$num[j])){
      juvenile1$parent_num1[i]<-as.character(parent_bp$sprout..old.[j])
      break
    }
  }
}


juvenile2<-juvenile1[,c(-2)]
sum_parent<-summaryBy(formula = dbh0+da+ba+survival_ba~color+sprout..old.,data=parent_bp,FUN=c(mean,length))
sum_juvenile<-summaryBy(formula = X04DBHmm+juvenile_ba~parent_color+parent_num1,data=juvenile2,FUN=c(mean,length))
names(sum_parent)[ which( names(sum_parent)=="sprout..old." ) ] <- "parent_num1"
names(sum_parent)[ which( names(sum_parent)=="color" ) ] <- "parent_color"

sum_parent$survival_num<-sum_parent$dbh0.length*sum_parent$da.mean
sum_parent1<-sum_parent[c(1,2,3,4,5,6,7,11)]
sum_juvenile$sum_ba<-sum_juvenile$juvenile_ba.mean*sum_juvenile$juvenile_ba.length
sum_juvenile3<-sum_juvenile[c(1,2,3,4,5,7)]

sum1<-merge(sum_parent1,sum_juvenile3,by=c("parent_num1","parent_color"),all = TRUE)
sum2<-merge(sum_parent,sum_juvenile,by=c("parent_num1","parent_color"))
sum3<-subset(sum1,is.na(sum1$dbh0.mean))
sum4<-subset(sum1,!is.na(sum1$dbh0.mean))

sum41<-sum4[,c(-1,-2)]

colnames(sum41)<-c("parent_dbh",
                   "parent_survival",
                   "parent_ba",
                   "parent_survival_ba",
                   "parent_num",
                   "parent_survival_num",
                   "juv_dbh",
                   "juv_ba",
                   "juv_num",
                   "juv_ba_sum")
sum41$juv_dbh[is.na(sum41$juv_dbh)]<-0
sum41$juv_num[is.na(sum41$juv_num)]<-0
sum41$juv_ba[is.na(sum41$juv_ba)]<-0
sum41$juv_ba_sum[is.na(sum41$juv_ba_sum)]<-0
library(GGally)
g<-ggpairs(data=sum41)
print(g)
plotList <- list()
test<-data.frame

#col<-colnames(sum41)
k=1

name1<-colnames(sum41)
for (i in 1:6){
  for (j in 7:10){
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
             nrow=4,ncol=6,
             xAxisLabels = c("parent_dbh",
                 "parent_survival",
                 "parent_ba",
                 "parent_survival_ba",
                 "parent_num",
                 "parent_survival_num"),
              yAxisLabels=c("juv_dbh",
                 "juv_ba",
                 "juv_num",
                 "juv_ba_sum"),
             byrow = FALSE)
print(pm)
# for (i in 1:6) {
#   plotList[[i]] <- ggally_text(paste("Plot #", i, sep = ""))
# }
# pm <- ggmatrix(
#   plotList,
#   2, 3,
#   c("A", "B", "C"),
#   c("D", "E"),
#   byrow = TRUE
# )
# print(pm)