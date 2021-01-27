motodata<-read.csv("nenrin/nenrin1.csv")

data1<-subset(motodata,motodata$spp=="lc")
data2<-subset(motodata,motodata$spp=="bp")
data3<-subset(motodata,motodata$spp=="pt")

model1<-lm(age~dbh+0,data=data1)
model2<-lm(age~dbh+0,data=data2)
model3<-lm(age~dbh+0,data=data3)

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
names(df4)[5]<-"dbh"
df4$age<-predict(model2,df4)
df4$age<-as.integer(df4$age)

df4<-df3[c("x","y","sp","age","dbh","X.1","spnum")]
names(df4)[5]<-"dbh"
names()
#write.csv(df4,"setting/init_fire0302.csv",row.names = FALSE)
#write.csv(df4,"setting/init_fire_bp0118.csv",row.names = FALSE)


summary(df1)
sp<-"bp"


df1<-motoint<-read.csv("int0313.csv")

#df1<-subset(df1,df1$spp==sp)
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
df41<-subset(df4,df4$sp==1)
df41$age<-predict(model1,df41)
df42<-subset(df4,df4$sp==2)
df42$age<-predict(model2,df42)
df43<-subset(df4,df4$sp==3)
df43$age<-predict(model3,df43)
df5<-rbind(df41,df42,df43)
df6<-subset(df5,df5$dbh>0)
df6$age<-as.integer(df6$age)
names(df6)[1]<-"#x"
#write.csv(df6,"setting/init_int0120.csv",row.names = FALSE)


df1<-read.csv("ctrl0315.csv")
df1$sp<-0
df1$sp[df1$spp=="lc"]<-1
df1$sp[df1$spp=="bp"]<-2
df1$sp[df1$spp=="pt"]<-3
df3<-subset(df1,df1$sp!=0)
df3$age<-100
df4<-df3
#df3<-subset(df3,df3$sp==spp)
df4<-df3[c("x","y","sp","age","dbh01","X.num","sprout")]
names(df4)[5]<-"dbh"
df41<-subset(df4,df4$sp==1)
df41$age<-predict(model1,df41)
df42<-subset(df4,df4$sp==2)
df42$age<-predict(model2,df42)
df43<-subset(df4,df4$sp==3)
df43$age<-predict(model3,df43)
df5<-rbind(df41,df42,df43)
df6<-subset(df5,df5$dbh>0)
df6$age<-as.integer(df6$age)+1
summary(df6)

df6<-subset(df6,df6$x>=0.0)
df6<-subset(df6,df6$x<=100.0)
df6<-subset(df6,df6$y>=0.0)
df6<-subset(df6,df6$y<=50.0)
names(df6)[1]<-"#x"

#write.csv(df6,"setting/init_ctr0126.csv",row.names = FALSE)
