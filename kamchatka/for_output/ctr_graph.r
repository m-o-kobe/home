library(ggplot2)

title1="200yr_plot"
ctr<-read.csv("ctrl0315.csv")
ctr1<-subset(ctr,ctr$dbh01>0.0)
ctr21<-subset(ctr1,ctr1$spp=="lc")
ctr22<-subset(ctr1,ctr1$spp=="bp")
ctr23<-subset(ctr1,ctr1$spp=="pt")
ctr2<-rbind(ctr21,ctr22,ctr23)
summary(ctr1$spp)
ctr2$sp[ctr2$spp=="lc"]<-"Larix_cajanderi"
ctr2$sp[ctr2$spp=="bp"]<-"Betula_platyphylla"
ctr2$sp[ctr2$spp=="pt"]<-"Populus_tremula"

output <-ggplot(ctr2, aes(y, x, size=dbh01, colour=sp))+
  geom_point(alpha=0.4)+
  coord_fixed(ratio=1)+
  labs(x="X", y="Y", title=title1, size="DBH", colour="Species")+
  theme(plot.margin=unit(c(0,0,0,0),"lines"))+
  theme_bw()+
  scale_radius(name="DBH", breaks=seq(0,50,by=10),limits=c(0,50),range=c(0,15))+
  #scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
  scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
  scale_y_continuous(breaks=seq(0,100,by=10), limits=c(-2,102))+
  scale_colour_manual(values = c(Larix_cajanderi="#00BA38",Betula_platyphylla="#F8766D",Populus_tremula="#619CFF"))

print( output )


g<-ggplot(data=ctr2,mapping=aes(x=dbh01,fill=sp))+
  scale_fill_manual(values = c(Larix_cajanderi="#00BA38",Betula_platyphylla="#F8766D",Populus_tremula="#619CFF"))+
  
  geom_histogram(binwidth = 5,position = "dodge")
#geom_histogram(position = "dodge")
label<-labs(title=title1)#+xlim(0,30)
#    label<-labs(title="simulate_1year")
g<-g+label+ xlab("dbh(cm)")#+    ylim(0,30)

print(g)


title1="40yr_plot"
ctr<-read.csv("int0313.csv")
ctr1<-subset(ctr,ctr$dbh01>0.0)
ctr21<-subset(ctr1,ctr1$spp=="lc")
ctr22<-subset(ctr1,ctr1$spp=="bp")
ctr23<-subset(ctr1,ctr1$spp=="pt")
ctr2<-rbind(ctr21,ctr22,ctr23)
ctr2$sp[ctr2$spp=="lc"]<-"Larix_cajanderi"
ctr2$sp[ctr2$spp=="bp"]<-"Betula_platyphylla"
ctr2$sp[ctr2$spp=="pt"]<-"Populus_tremula"
summary(ctr2)
ctr2$y<-ctr2$y+50

output <-ggplot(ctr2, aes(x=x, y=y, size=dbh01, colour=sp))+
  geom_point(alpha=0.4)+
  coord_fixed(ratio=1)+
  labs(x="X", y="Y", title=title1, size="DBH", colour="Species")+
  theme(plot.margin=unit(c(0,0,0,0),"lines"))+
  theme_bw()+
  scale_radius(name="DBH", breaks=seq(0,50,by=10),limits=c(0,50),range=c(0,15))+
  #scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
  scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
  scale_y_continuous(breaks=seq(0,100,by=10), limits=c(-2,102))+
  scale_colour_manual(values = c(Larix_cajanderi="#00BA38",Betula_platyphylla="#F8766D",Populus_tremula="#619CFF"))

print( output )


g<-ggplot(data=ctr2,mapping=aes(x=dbh01,fill=sp))+
  scale_fill_manual(values = c(Larix_cajanderi="#00BA38",Betula_platyphylla="#F8766D",Populus_tremula="#619CFF"))+
  
  geom_histogram(binwidth = 5,position = "dodge")
#geom_histogram(position = "dodge")
label<-labs(title=title1)#+xlim(0,30)
#    label<-labs(title="simulate_1year")
g<-g+label+ xlab("dbh(cm)")#+    ylim(0,30)

print(g)

motofire<-read.csv("fire_maiboku0212.csv")
df1<-motofire
subset(df1,is.na(df1$xx))

df1$xx<-as.numeric(df1$grid..x.)+as.numeric(as.character((df1$x)))
df1$yy<-as.numeric(df1$grid..y.)+as.numeric(as.character((df1$y)))
df2<-df1
df2$sp<-0
df2$sp[df2$sp.=="La"]<-"Larix_cajanderi"
df2$sp[df2$sp.=="Be"]<-"Betula_platyphylla"
df2$sp[df2$sp.=="Po"]<-"Populus_tremula"
df2$sp<-as.factor(df2$sp)
df3<-subset(df2,df2$sp!=0)
output <-ggplot(df3, aes(x=xx, y=yy, size=dbh0, colour=sp,shape=D.A..2000.))+
  geom_point(alpha=0.4)+
  coord_fixed(ratio=1)+
  labs(x="X", y="Y", title="2yr", size="DBH", colour="Species",shape="生死")+
  theme(plot.margin=unit(c(0,0,0,0),"lines"))+
  theme_bw()+
  scale_radius(name="DBH", breaks=seq(0,50,by=10),limits=c(0,50),range=c(0,15))+
  #scale_x_continuous(breaks=seq(0,50,by=10), limits=c(-2,52))+
  scale_x_continuous(breaks=seq(0,90,by=10), limits=c(-2,92))+
  scale_y_continuous(breaks=seq(0,100,by=10), limits=c(-2,102))+
  scale_shape_manual(values=c(1,13))+
  scale_colour_manual(values = c(Larix_cajanderi="#00BA38",Betula_platyphylla="#F8766D",Populus_tremula="#619CFF"))

print( output )

g<-ggplot(data=df3,mapping=aes(x=dbh0,fill=sp))+
  scale_fill_manual(values = c(Larix_cajanderi="#00BA38",Betula_platyphylla="#F8766D",Populus_tremula="#619CFF"))+
  
  geom_histogram(binwidth = 5,position = "dodge")
#geom_histogram(position = "dodge")
label<-labs(title="before_fire")#+xlim(0,30)
#    label<-labs(title="simulate_1year")
g<-g+label+ xlab("dbh(cm)")#+    ylim(0,30)

print(g)
df4<-subset(df3,df3$D.A..2000.=="A")
g<-ggplot(data=df4,mapping=aes(x=dbh0,fill=sp))+
  scale_fill_manual(values = c(Larix_cajanderi="#00BA38",Betula_platyphylla="#F8766D",Populus_tremula="#619CFF"))+
  
  geom_histogram(binwidth = 5,position = "dodge")
#geom_histogram(position = "dodge")
label<-labs(title="after_fire")#+xlim(0,30)
#    label<-labs(title="simulate_1year")
g<-g+label+ xlab("dbh(cm)")#+    ylim(0,30)

print(g)
