library(vegan)
library(GGally)

data11<-read.csv("kakuron.csv",stringsAsFactors=FALSE)
data12<-read.csv("kakuron2.csv",stringsAsFactors=FALSE)
data13<-read.csv("kakuron3.csv",stringsAsFactors=FALSE)
data14<-read.csv("kakuron4.csv",stringsAsFactors=FALSE)
data15<-read.csv("kakuron5.csv",stringsAsFactors=FALSE)



data1<-merge(data11,data12)
data1<-merge(data1,data13)
data1<-merge(data1,data14)
data1<-merge(data1,data15)

data1<-data1[, colSums(is.na(data1)) != nrow(data1)]
rownames(data1)<-data1$都道府県
class(data1$都道府県)
data2<-data1[-c(1)]

data7<-data1
for (i in 2:12) {              # for (ループ変数 in ベクトルやリスト)
  data7[,i]<-48-rank(data7[,i])
}  

write.csv(data1,file="kakuronoutput.csv")

for (i in 1:11) {              # for (ループ変数 in ベクトルやリスト)
  data2[,i]<-as.numeric(data2[,i])
}  

data2<-data2/as.numeric(data1$総人口)
data2$総人口<-as.numeric(data1$総人口)


data3<-scale(data2)
data4<-data.frame(data3)

# 距離の計算
data5 <- dist(data4)^2    # ユークリッド距離の平方（2乗)

# クラスター分析（Ward法と平方ユークリッド距離使用）
result <- hclust(data5, method="ward")

# デンドログラム作図
plot(result)

cluster <- cutree(result, k=3)  # K=でいくつのクラスターに分けるか指定
cluster <- factor(cluster)      # 因子の型に変更
table(cluster)                  # それぞれのクラスターの人数確認

data6 <- cbind(data4, cluster)        # 標準得点のデータフレーム

g<-ggpairs(data=data6,mapping=aes(color=cluster),
        columns=1:12)
print(g)
by(data6[,1:6], data6$cluster, mean)  # 素点

attach(y)          # dat$TOEICとわざわざ書かなくていいようにattach
par(mfrow=c(2,3))  # 縦に2つ，横に3つのグラフを並べる


pca = prcomp(data4, scale=T)

# 主成分分析の結果をプロットします。
biplot(pca)
summary(pca)

summary(data2)

