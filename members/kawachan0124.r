library(spatstat)

win1<-owin(poly=list(list(x=c(0,30,30,0),
                          y=c(0,0,70,70)),
               list(x=c(10,40,40,10),
                    y=c(70,70,90,90))))
plot(win1)
