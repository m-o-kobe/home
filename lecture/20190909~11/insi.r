# 2 つの CSV ファイルを読み込み
library(doBy)
DFall <- read.csv('dataset-B/move-pref-all.csv', stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
DFpop <- read.csv('dataset-B/population-pref.csv', stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
DFborn <- read.csv('dataset-B/born_rate.csv', stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
DFin <- read.csv('dataset-B/tennyu.csv', stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
DFout <- read.csv('dataset-B/tenshutsu.csv', stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
DFage<-merge(DFin,DFout)
colnames(DFborn)[1]<-"origin"
#str(DFpop)
#summary(DFpop)
# '全国' の列は必要ないので削除したものを作る
rownames(DFpop) <- DFpop$year
DFpop2 <- subset(DFpop, select = -c(year, 全国))

DFpop_long <- stack(DFpop2)
# 'year' の列を追加
DFpop_long$year = c(2010:2018)
#データフレームを結合するため，列名を揃える
colnames(DFpop_long) <- c('population', 'origin', 'year')
# 結合を実行 (merge)
#DFm <- merge(DFall, DFpop_long)

# 県人口 1000 人あたりの移動率の列を作成
#DFm$ratepermill = DFm$migration / DFm$population * 1000
DFmale<-subset(DFall,DFall$gender=="男")
DFfemale<-subset(DFall,DFall$gender=="女")
DFfemale<-DFfemale[, c("year","origin","destination","migration")]
DFmale<-DFmale[, c("year","origin","destination","migration")]
colnames(DFfemale)[4]<-"female"
colnames(DFmale)[4]<-"male"

DFfm<-merge(DFmale,DFfemale)
gyakuDFfm<-DFfm
colnames(gyakuDFfm)[3]<-"origin"
colnames(gyakuDFfm)[2]<-"destination"
colnames(gyakuDFfm)[4]<-"inmale"
colnames(gyakuDFfm)[5]<-"infemale"
gyakuDFfm<-gyakuDFfm[,c("year","origin","destination","inmale","infemale")]
tokusei<-merge(DFfm,gyakuDFfm)

matome<-summaryBy(male+female+inmale+infemale~origin,data=tokusei)
DFpop_long<-summaryBy(population~origin,data=DFpop_long)
DFtokusei <- merge(matome, DFpop_long)
DFtokusei$emig<-1000*(DFtokusei$male+DFtokusei$female)/DFtokusei$population.mean
DFtokusei$inmig<-1000*(DFtokusei$inmale+DFtokusei$infemale)/DFtokusei$population.mean
DFtokusei$emifm<-DFtokusei$male.mean/DFtokusei$female.mean
DFtokusei$infm<-DFtokusei$inmale.mean/DFtokusei$infemale.mean
DFtokusei<-merge(DFtokusei,DFborn)
DFforp<-DFtokusei[,c(6,7,8,9,10,11)]
DFforp$inout<-DFforp$inmig/DFforp$emig
colnames(DFforp)<- c('人口', '移出率', '移入率',"移出男女比","移入男女比","出生率","転入超過")
p1<-prcomp(DFforp,scale=TRUE)

rownames(p1$x)<-DFtokusei[,1]
biplot(p1)
barplot(p2$rot[,1])

DFage<-merge(DFage,DFtokusei)

DFminus<-DFtokusei[,c(-2,-3,-4,-5)]
ageori<-DFage[, c("origin","in.15","in16.20","in21.25","in26.59","in60.","out.15","out16.20","out21.25","out26.59","out60.")]
DFmatome<-merge(DFminus,ageori)

g<-ggpairs(DFmatome[,c(-1,-3,-4,-5,-6,-7)],aes(alpha=0.5))
print(g)

# CSV ファイルとして出力
graph<-ggplot(data=DFmatome,mapping=aes(x=in.15,y=in21.25,label=origin))+geom_point()+
  geom_text()
print(graph)
# 少し複雑な条件指定の例
DFm[(DFm$year == 2015) & (DFm$origin == '東京都') & (DFm$gender == '総数'), ]
DFm[(DFm$year == 2015) & (DFm$destination == '東京都') & ((DFm$gender == '男') | (DFm$gender == '女')), ]
