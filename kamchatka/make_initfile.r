#make new initfile
motofire<-read.csv("fire_maiboku0212.csv")
df1<-motofire
subset(df1,is.na(df1$xx))

df1$xx<-as.numeric(df1$grid..x.)+as.numeric(as.character((df1$x)))
df1$yy<-as.numeric(df1$grid..y.)+as.numeric(as.character((df1$y)))
df2<-df1
df2$sp<-0
df2$sp[df2$sp.=="La"]<-1
df2$sp[df2$sp.=="Be"]<-2
df2$sp[df2$sp.=="Po"]<-3
df3<-subset(df2,df2$sp!=0)
#df3<-subset(df3,df3$D.A......2004.=="A")
#↑生存のみ出力用
df3$age<-100
df3$spnum<-as.integer(df3$sprout..old.)
df4<-df3[c("xx","yy","sp","age","dbh0","X.1","spnum")]
write.csv(df4,"setting/init_fire0302.csv",row.names = FALSE)


summary(df1)

