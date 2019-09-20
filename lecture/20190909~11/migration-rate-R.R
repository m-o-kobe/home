# 2 つの CSV ファイルを読み込み
DFall <- read.csv('dataset-B/move-pref-all.csv', stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
DFpop <- read.csv('dataset-B/population-pref.csv', stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
DFkyori <- read.csv('dataset-B/kyori2.csv', stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM",)
#str(DFall)
#summary(DFall)
#str(DFpop)
#summary(DFpop)
# '全国' の列は必要ないので削除したものを作る
rownames(DFpop) <- DFpop$year
DFpop2 <- subset(DFpop, select = -c(year, 全国))
#DFpop2
DFpop_long <- stack(DFpop2)
# 'year' の列を追加
DFpop_long$year = c(2010:2018)

#データフレームを結合するため，列名を揃える
colnames(DFpop_long) <- c('oripop', 'origin', 'year')
# 結合を実行 (merge)
DFm <- merge(DFall, DFpop_long)

colnames(DFpop_long) <- c('despop', 'destination', 'year')

DFm<-merge(DFm,DFpop_long)
#DFn<-DFm[,c()]
DFm<-merge(DFm,DFkyori)
DFm.lm<-lm(formula=migration~oripop+despop+kyori,data=DFm)
summary(DFm.lm)
DFjogai<-subset(DFm,DFm$origin!=DFm$destination)
DFjogai<-subset(DFjogai,DFjogai$gender=="総数")
DFjogai$kyori_1<-1/DFjogai$kyori
#DFjogai$kyori_1<-1/(DFjogai$kyori)^2


DFjogai.lm<-lm(formula=migration~oripop+despop+kyori_1+oripop:despop+oripop:kyori_1+despop:kyori_1,data=DFjogai)
step.lm<-step(DFjogai.lm)

sum<-summary(step.lm)
coe<-sum$coefficient

DFjogai$yosoku<-coe[1]+coe[2]*DFjogai$oripop+coe[3]*DFjogai$despop+coe[4]*DFjogai$kyori_1+coe[5]*DFjogai$oripop*DFjogai$despop+coe[6]*DFjogai$oripop*DFjogai$kyori_1+coe[7]*DFjogai$despop*DFjogai$kyori_1
g<-ggplot(data=DFjogai,aes(x=yosoku,y=migration,colour=origin))+geom_point()

# 県人口 1000 人あたりの移動率の列を作成
#DFm$ratepermill = DFm$migration / DFm$oripop * 1000

# CSV ファイルとして出力
#write.csv(DFm, 'move-pref-rate.csv', row.names = FALSE, fileEncoding = "UTF-8")

# 少し複雑な条件指定の例
#DFm[(DFm$year == 2015) & (DFm$origin == '東京都') & (DFm$gender == '総数'), ]
#DFm[(DFm$year == 2015) & (DFm$destination == '東京都') & ((DFm$gender == '男') | (DFm$gender == '女')), ]
