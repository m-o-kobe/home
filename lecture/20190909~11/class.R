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
DF<-subset(DFall,DFall$year=2018)
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

DFm<-merge(DFm,DFkyori)

# 県人口 1000 人あたりの移動率の列を作成
#DFm$ratepermill = DFm$migration / DFm$population * 1000

# CSV ファイルとして出力
write.csv(DFm, 'move-pref-rate.csv', row.names = FALSE, fileEncoding = "UTF-8")

# 少し複雑な条件指定の例
#DFm[(DFm$year == 2015) & (DFm$origin == '東京都') & (DFm$gender == '総数'), ]
#DFm[(DFm$year == 2015) & (DFm$destination == '東京都') & ((DFm$gender == '男') | (DFm$gender == '女')), ]
