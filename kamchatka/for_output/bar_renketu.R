g<-ggplot(data=dat,mapping=aes(x=V6,fill=sp))+
  #geom_histogram(binwidth = 5,position = "dodge")
  geom_histogram(bins=30,position = "dodge")
label<-labs(title=paste(title1,"Year: ",year))#+xlim(0,30)
#    label<-labs(title="simulate_1year")
g<-g+label+ xlab("dbh(cm)")#+    ylim(0,30)

print(g)

ctr<-read.csv("ctrl0315.csv")
ctr_g<-ggplot(data=ctr_bp,mapping=aes(x=dbh01,fill=spp))+
  geom_histogram(bins=30,position="dodge")+
  labs(title="ctr_bp")   
print(ctr_g)


int160<-dat$V6
int160<-as.data.frame(int160)
names(int160)[1]<-"dbh01"

int160$plot<-"int160"
ctr_b<-ctr_bp$dbh01
ctr_b<-as.data.frame(ctr_b)
names(ctr_b)[1]<-"dbh01"
ctr_b$plot<-"ctr"

renketu<-rbind(ctr_b,int160)
renketu$sp<-"bp"

g<-ggplot(data=renketu,mapping=aes(x=dbh01,fill=plot))+
  geom_histogram(position = "dodge")
label<-labs(title=paste(title1,"Year: ",year))#+xlim(0,30)
g<-g+label+ xlab("dbh(cm)")#+    ylim(0,30)
print(g)



ctr_bp$plot<-"ctr"
int_bp$plot<-"int"
ketugou<-rbind(ctr_bp,int_bp)


h_simu<-hist(dat$V6, breaks=seq(0,30,3))
h_simu$counts<-h_simu$counts/0.9
h_int<-hist(int_bp$dbh01,breaks=seq(0,30,3))
h_int$counts<-h_int$counts/0.5
h_ctr<-hist(ctr_bp$dbh01,breaks=seq(0,30,3))
h_ctr$counts<-h_ctr$counts/0.5
plot(h_int)
plot(h_simu)

int_forplot <- data.frame(dbh=h_int$mids,counts=h_int$counts)
int_forplot$plot<-"int"
ctr_forplot<-data.frame(dbh=h_ctr$mids,counts=h_ctr$counts)
ctr_forplot$plot<-"ctr"

simu_forplot <- data.frame(dbh=h_simu$mids,counts=h_simu$counts)
simu_forplot$plot<-"simu"


forplot<-rbind(ctr_forplot,simu_forplot)
forplot<-rbind(int_forplot,simu_forplot)

g<-ggplot(data=forplot,aes(x=dbh,y=counts,fill=plot))+
  geom_bar(stat="identity",position="dodge")
print(g)
