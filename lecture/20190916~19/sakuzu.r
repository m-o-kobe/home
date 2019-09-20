#因果推論 pcalgパッケージ
library(GGally)
library(ggplot2)
library(ggthemes)
"+" = function(e1, e2){
  if(is.character(c(e1, e2))){
    paste(e1, e2, sep="")
  }else{
    base::"+"(e1, e2)
  }
}
loess_with_cor <- function(data, mapping, ..., method = "pearson") {
  x <- eval(mapping$x, data)
  y <- eval(mapping$y, data)
  cor <- cor(x, y, method = method)
  ggally_smooth_loess(data, mapping, ...) +
    ggplot2::geom_label(
      data = data.frame(
        x = min(x, na.rm = TRUE),
        y = max(y, na.rm = TRUE),
        lab = round(cor, digits = 3)
      ),
      mapping = ggplot2::aes(x = x, y = y, label = lab),
      hjust = 0, vjust = 1,
      size = 5, fontface = "bold",
      inherit.aes = FALSE # do not inherit anything from the ...
    )
}
DFc<-read.csv("ds4_brand2018_b.csv")
DBcall<-subset(DFc,DFc$row=="全体")
DBcall<-subset(DBcall,DBcall$gyo2==1)
g<-ggduo(DBcall1,
      columnsX=88:98,
      columnsY=10,
      showStrips = FALSE
      )
DBcall

PlotList<-list()
DF<-data.frame(b1 = numeric(0), b2 = numeric(0),col = numeric(0),cor=numeric(0))
for(i in 10:11){
i=10
    for(j in 88:111){
   fordraw<-data.frame(b1=as.numeric(DBcall[,i]),b2=as.numeric(DBcall[,j]),col=colnames(DBcall[i])+"_"+colnames(DBcall[j]),brand_id=DBcall[1]==47)
   DF<-rbind(DF,fordraw)
   PlotList[[colnames(DBcall[i])+"_"+colnames(DBcall[j])]]<-cor(as.numeric(DBcall[,i]),as.numeric(DBcall[,j]))
   }
}
DF[DF$brand_id!=47]$brand_id<-"その他"
plot(PlotList)
class(k)
p <- ggplot(DF, aes(x=b2, y=b1,fill=brand_id,shape=brand_id))+
  geom_point()+
  facet_wrap(~col,scales="free",ncol=8)+
  scale_shape_manual(values = c(21, 24)) +
  scale_fill_manual(values = c("yellow", "red"),guide = guide_legend(override.aes = list(shape = 22)))
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