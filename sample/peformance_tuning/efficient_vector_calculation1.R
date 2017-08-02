# 1からNまでの自然数の対数を合算する関数
sillysum <- function(N){
  res <- 0
  for(i in seq(N)){
    res <- res + log(i)
  }
  res
}

# 計算を実行して時間を計測
system.time(ss <- sillysum(1e7))
ss

# 1からNまでの自然数の対数を合算する関数（ベクトルで計算）
efficientsum <- function(N){
  sum(log(seq(N)))
}

# 計算を実行して時間を計測
system.time(es <- efficientsum(1e7))
es