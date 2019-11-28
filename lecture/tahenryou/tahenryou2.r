library(HistData)
library(ggplot2)
library(GGally)
data(Galton)

g <- ggplot(Galton, aes(x = child))
g <- g + geom_histogram(binwidth=1)+ggtitle("child")
plot(g)

g <- ggplot(Galton, aes(x = parent))
g <- g + geom_histogram(binwidth=1)+ggtitle("parent")
plot(g)

var.test(Galton$parent,Galton$child)


parent1<-data.frame
g<-ggpairs(data=Galton,
           columns=1:2,diag=list(continuous="barDiag"),
           lower = list(continuous = wrap("smooth", alpha = 0.1, size=0.5)))
print(g)

t.test(Galton$parent, Galton$child, var.equal=F)
mean(Galton$parent)
mean(Galton$child)
var(Galton$parent)
var(Galton$child)
fit1<-lm(Galton$child~Galton$parent)
summary(fit1)
anova(fit1)