df1<-read.csv("test.csv")
covar.test <- function(      dat,                                            # データ行列
                             cp1,                                            # 独立変数の列番号
                             cp2,                                            # 従属変数の列番号
                             cp3)                                            # 群変数の列番号
{
  dat <- subset(dat, complete.cases(dat[,c(cp1, cp2, cp3)]))   # 欠損値を持つケースを除く
  x <- dat[,cp1]                                                       # 独立変数
  y <- dat[,cp2]                                                       # 従属変数
  g <- dat[,cp3]                                                       # 群変数
  
  nj <- table(g)                                                       # 各群の例数
  n <- sum(nj)                                                 # 全例数
  k <- length(nj)                                                      # 群の個数
  # 独立変数について
  mx <- mean(x)                                                        # 全体の平均値
  mxj <- tapply(x, g, mean)                                    # 各群の平均値
  sstx <- (n-1)*var(x)                                         # 全変動
  ssbx <- sum(nj*(mxj-mx)^2)                                   # 群間変動
  sswx <- sstx-ssbx                                            # 群内変動
  # 従属変数について
  my <- mean(y)                                                        # 全体の平均値
  myj <- tapply(y, g, mean)                                    # 各群の平均値
  ssty <- (n-1)*var(y)                                         # 全変動
  ssby <- sum(nj*(myj-my)^2)                                   # 群間変動
  sswy <- ssty-ssby                                            # 群内変動
  
  spt <- (n-1)*cov(x, y)                                               # 共変動
  spb <- sum(nj*(mxj-mx)*(myj-my))                             # 群間共変動
  spw <- spt-spb                                                       # 群内共変動
  
  ss.wy <- sswy-spw^2/sswx                                     # 全群に共通な傾きと各群ごとの切片を持つ回帰直線からの変動
  ss.ty <- ssty-spt^2/sstx                                     # 全データに基づく回帰直線からの変動
  ss.by <- ss.ty-ss.wy                                         # 各群の回帰の差に起因する変動
  
  hensa.x <- x-mxj[g]                                          # 各群の平均値からの偏差
  hensa.y <- y-myj[g]                                          # 各群の平均値からの偏差
  xy <- hensa.x*hensa.y 
  xx <- hensa.x^2
  numerator <- tapply(xy, g, sum)
  denominator <- tapply(xx, g, sum)
  a <- numerator/denominator                                   # 各群のデータに基づく回帰直線の傾き
  b <- myj-a*mxj                                                       # 各群のデータに基づく回帰直線の切片
  predict.y <- a[g]*x+b[g]                                     # 各群ごとのデータに基づく回帰直線による予測値
  ss.wyj <- sum((y-predict.y)^2)                                       # 各群ごとのデータに基づく回帰直線からの変動
  
  df.r <- k-1
  df.e <- n-2*k
  df.t <- n-k-1
  
  diff.reg <- ss.wy-ss.wyj                                     # 各群の回帰の差による推定誤差平方和
  ms.r <- diff.reg/df.r                                                # 各群の回帰の差による推定誤差分散
  ms.e <- ss.wyj/df.e                                          # 各群の推定誤差の和による推定誤差分散
  ms.w <- ss.wy/df.t                                           # 平均回帰に基づく推定誤差による推定誤差分散
  f <- ms.r/ms.e                                                       # 検定統計量
  p <- pf(f, df.r, df.e, lower.tail=FALSE)                     # P 値
  anova.table <- data.frame(                                   # 分散分析表としてまとめる
    "SS"=c(diff.reg, ss.wyj, ss.wy),
    "d.f."=c(df.r, df.e, df.t),
    "MS"=c(ms.r, ms.e, ms.w)
  )
  rownames(anova.table) <- c("group x slope", "residual", "total")# 行の名前
  test.result <- c("F value"=f, "d.f.1"=df.r, "d.f.2"=df.e, "P value"=p)
  
  if (p <= 0.05) {                                             # 各群における回帰直線が等しくないとき，
    part2 <- anova.table2 <- test.result2 <- NULL          # それ以上の検定は行わない
  }
  else {                                                          # 各群における回帰直線の傾きが等しくないとはいえないとき
    part2 <- "H0: 共変量で調整した平均値は同じである"    # 帰無仮説
    ms.by <- ss.by/df.r
    ms.wy <- ss.wy/df.t
    anova.table2 <- data.frame(                          # 分散分析表としてまとめる
      "SS"=c(ss.by, ss.wy, ss.ty),
      "d.f."=c(df.r, df.t, n-2),
      "MS"=c(ms.by, ms.wy, ss.ty/(n-2))
    )
    rownames(anova.table2) <- c("effect & group", "residual", "total")# 行の名前
    f2 <- ms.by/ms.wy                                    # 検定統計量
    p2 <- pf(f2, df.r, df.t, lower.tail=FALSE)                   # P 値
    test.result2 <- c("F value"=f2, "d.f.1"=df.r, "d.f.2"=df.t, "P value"=p2)
  }
  return(list(    part1="H0: 各群の回帰直線の傾きは同じである",
                  result1.1=anova.table,
                  result1.2=test.result,
                  part2=part2,
                  result2.1=anova.table2,
                  result2.2=test.result2))
}


reg.line.diff <- function(X1, Y1, X2, Y2){
  X <- c(X1,X2)
  Y <- c(Y1,Y2)
  X1bar <- mean(X1)
  X2bar <- mean(X2)
  Xbar  <- mean(X)
  Y1bar <- mean(Y1)
  Y2bar <- mean(Y2)
  Ybar  <- mean(Y)
  SSXY1 <- sum((X1-X1bar)*(Y1-Y1bar))
  SSXY2 <- sum((X2-X2bar)*(Y2-Y2bar))
  SSXY  <- sum((X-Xbar)*(Y-Ybar))
  SSX1  <- sum((X1-X1bar)^2)
  SSX2  <- sum((X2-X2bar)^2)
  SSX   <- sum((X-Xbar)^2)
  SSY1  <- sum((Y1-Y1bar)^2)
  SSY2  <- sum((Y2-Y2bar)^2)
  SSY   <- sum((Y-Ybar)^2)
  
  Delta1 <- SSY1-(SSXY1)^2/SSX1 + SSY2-(SSXY2)^2/SSX2
  Delta2 <- SSY1+SSY2 - (SSXY1+SSXY2)^2/(SSX1+SSX2)
  n <- length(X1)
  m <- length(X2)
  N  <- n+m
  Fb <- (Delta2-Delta1)/(Delta1/(N-4))
  pb <- pf(Fb, 1, N-4, lower.tail=F)
  b1 <- SSXY1/SSX1
  b2 <- SSXY2/SSX2
  a1 <- Y1bar-b1*X1bar
  a2 <- Y2bar-b2*X2bar
  bE <- (SSXY1+SSXY2)/(SSX1+SSX2)
  
  Delta3 <- SSY-(SSXY)^2/SSX
  Fa <- (Delta3-Delta2)/(Delta2/(N-3))
  pa <- pf(Fa, 1, N-3, lower.tail=F)
  aE1 <- Y1bar-bE*X1bar
  aE2 <- Y2bar-bE*X2bar
  bT <- SSXY/SSX
  aT <- Ybar-bT*Xbar
  
  a.diff <- aE2-aE1
  a.diff.l <- a.diff-qt(1-0.05/2, N-3)*sqrt((1/n+1/m+(X1bar-X2bar)^2/(SSX1+SSX2))*(Delta2/(N-3)))
  a.diff.u <- a.diff+qt(1-0.05/2, N-3)*sqrt((1/n+1/m+(X1bar-X2bar)^2/(SSX1+SSX2))*(Delta2/(N-3)))
  conf <- qt(1-0.05/2, N-3)*sqrt((1/n+1/m+(X1bar-X2bar)^2/(SSX1+SSX2))*(Delta2/(N-3)))
  
  li_<-list(c(Delta1=Delta1, Delta2=Delta2, F_Slopes=Fb, p_Slopes=pb, 
         Delta3=Delta3, F_Intcps=Fa, p_Intcps=pa,
         Slope1=b1, Slope2=b2, Intcp1=a1, Intcp2=a2,
         Slope_Common=bE, Intcp1_Slope_Common=aE1, Intcp2_Slope_Common=aE2, 
         Diff_Intcps=a.diff, Diff_Intcps_LL=a.diff.l, Diff_Intcps_UL=a.diff.u,
         Slop_Total=bT, Intcp_Total=aT))
  df_<-data.frame(c(Delta1=Delta1, Delta2=Delta2, F_Slopes=Fb, p_Slopes=pb, 
         Delta3=Delta3, F_Intcps=Fa, p_Intcps=pa,
         Slope1=b1, Slope2=b2, Intcp1=a1, Intcp2=a2,
         Slope_Common=bE, Intcp1_Slope_Common=aE1, Intcp2_Slope_Common=aE2, 
         Diff_Intcps=a.diff, Diff_Intcps_LL=a.diff.l, Diff_Intcps_UL=a.diff.u,
         Slop_Total=bT, Intcp_Total=aT))
  df_
  
  }
summary(df1)
sp1<-subset(df1,df1$Species=="アラカシ")
sp2<-subset(df1,df1$Species=="イヌビワ")
reg.line.diff1 <- reg.line.diff(X1=sp1$dbh, Y1=sp1$rgr, X2=sp2$dbh, Y2=sp2$rgr)
reg.line.diff1[4,]

df2<-subset(df1,(df1$Species=="イヌビワ")|(df1$Species=="アオキ"))
covar.test(df2,"dbh","rgr","Species")


summary(lm(formula=rgr~dbh+Species,data=df2))
x<-df1$dbh
y<-df1$rgr
g<-df1$Species
pairwise.t.test(y,g,p.adjust.method = "holm")
