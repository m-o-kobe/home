library(ggplot2)
df1<-read.csv("yuikosan200612.csv")
kugiri<-25
df1$D_fact<-as.factor(as.integer(df1$Dv..m./kugiri)*kugiri)
g<-ggplot(data=df1,mapping=aes(x=height,fill=D_fact))+
  geom_histogram(position="dodge")
print(g)


g<-ggplot(data=df1,mapping=aes(x=height,fill=D_fact))+
  geom_histogram(position="dodge",binwidth=3.0)
print(g)
