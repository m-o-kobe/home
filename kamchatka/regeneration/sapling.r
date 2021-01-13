data<-read.csv("regeneration/larix_sapling.csv",fileEncoding = "UTF-8-BOM")

library(ggplot2)
library(MuMIn)
options(na.action = "na.fail")
g<-ggplot(data=data,aes(x=ageclass,y=density,colour=habitats))+
  geom_point()
print(g)
density1<-glm(formula=density~ageclass+habitats,data=data)
density2<-glm(formula=density~ageclass+habitats+0,data=data)

model_hikaku1<-dredge(density1,rank="BIC")
model_hikaku2<-dredge(density2,rank="BIC")
model_hikaku<-merge(model_hikaku1,model_hikaku2)
summary(density.glm)

density<-lm(formula=density~ageclass,data=data)
summary(density)
plot(data$ageclass,data$density)
abline(density)
