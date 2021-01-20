#make new initfile
motofire<-read.csv("fire_maiboku0212.csv")
df1<-motofire

df1$xx<-as.numeric(df1$grid..x.)+as.numeric(as.character((df1$x)))
df1$yy<-as.numeric(df1$grid..y.)+as.numeric(as.character((df1$y)))
df2<-df1
df2$sp<-0
df2$sp[df2$sp.=="La"]<-1
df2$sp[df2$sp.=="Be"]<-2
df2$sp[df2$sp.=="Po"]<-3
df3<-subset(df2,df2$sp!=0)
df3<-subset(df3,!is.na(df3$xx))

#df3<-subset(df3,df3$D.A......2004.=="A")
#↑生存のみ出力用
spp=2
df3<-subset(df3,df3$sp==spp)

df3$age<-100
df3$spnum<-as.integer(df3$sprout..old.)
df4<-df3[c("xx","yy","sp","age","dbh0","X.1","spnum")]
names(df4)[5]<-"dbh"
df4$age<-predict(model2,df4)
df4$age<-as.integer(df4$age)
names()
#write.csv(df4,"setting/init_fire0302.csv",row.names = FALSE)
#write.csv(df4,"setting/init_fire_bp0118.csv",row.names = FALSE)


summary(df1)
sp<-"bp"


df1<-motoint<-read.csv("int0313.csv")
df1<-subset(df1,df1$spp==sp)
df1$sp<-0
df1$sp[df1$spp=="lc"]<-1
df1$sp[df1$spp=="bp"]<-2
df1$sp[df1$spp=="pt"]<-3
df3<-subset(df1,df1$sp!=0)
df3$age<-100
#df3<-subset(df3,df3$sp==spp)
df4<-df3[c("x","y","sp","age","dbh01","X.num","sprout")]
names(df4)[5]<-"dbh"
df4$y<-df4$y+50.0

df4<-subset(df4,df4$x>=0.0)
df4<-subset(df4,df4$x<=50.0)
df4<-subset(df4,df4$y>=0.0)
df4<-subset(df4,df4$y<=100.0)
df4$age<-predict(model2,df4)
df4$age<-as.integer(df4$age)
write.csv(df4,"setting/init_int_bp0118.csv",row.names = FALSE)
