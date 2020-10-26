filename<-"int0313.csv"
int<-read.csv(filename)
pt_dat<-subset(int,int$spp=="pt")
pt_dat<-subset(pt_dat,pt_dat$dbh01>0)
g<-ggplot(data=pt_dat,mapping=aes(x=dbh01,fill=spp))+
  geom_histogram(binwidth = 5,position = "dodge")+
  labs(title="40yr_plot")+
  xlim(-5,30)+ylim(0,50)
#scale_fill_manual(values = c("Larix cajanderi"="#00BA38","Betula platyphylla"="#F8766D","Populus tremula"="#619cFF"))
print(g)

pt_dat$ba<-2*asin(1)*pt_dat$dbh01^2/4
sum(pt_dat$ba)/(0.5*10000)
