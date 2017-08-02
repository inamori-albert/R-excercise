set.seed(71)

# 大きな行列を作成
nr <- 1000
nc <- 1e5
x <- matrix(runif(nr * nc), nr, nc)

# 列ごとの最大値を求める
# オブジェクトを格納するメモリを確保しなおすので時間がかかる
res.silly <- NULL
system.time({
  for(j in seq(nc)){
    res.silly <- cbind(res.silly, max(x[,j]))
  }
})

# 列ごとの最大値を求める(apply関数を利用)
# 計算結果のオブジェクトのメモリを確保することで高速化
# 内部ではfor文を使っている
system.time(res.apply <- apply(x, 2, max))


# 列ごとの最大値を求める(はじめに計算結果を格納するメモリを確保することで高速化)
res.silly2 <- rep(NA, nc)
system.time({
  for(j in seq(nc)){
    res.silly2 <- max(x[,j])
  }
})

