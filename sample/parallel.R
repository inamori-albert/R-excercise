# parallelのサンプル
# 並列計算を行う

library(parallel)

# クラスタの生成
cores <- detectCores()
cl <- makeCluster(cores, type = "PSOCK")

# プロセスIDの表示
clusterCall(cl, Sys.getpid)

# 計算
i <- 1:5
parSapply(cl, i, function(x) x^2)

# 並列でランダムフォレスト
## データのロード
library(C50)
data(churn)

## 設定
ntree <- 1000
set.seed(71)

## クラスタごとの乱数ストリームの設定
clusterSetRNGStream(cl)

clusterExport(cl, "churnTrain")

# 実行する関数の設定
calc_randomForest <- function(nt){
  library(randomForest)
  randomForest(churn ~ ., data = churnTrain, ntree = nt)  
}

## ランダムフォレストの並列計算を実行(書くコアで250個の決定木の生成)
system.time(
  res.par <- parLapply(cl, rep(ntree/cores, cores), calc_randomForest)
)

# クラスタの停止
stopCluster(cl)

## ランダムフォレスト単一ノードで実行
library(randomForest)
system.time(
  res.nopar <- randomForest(churn ~ ., data = churnTrain, ntree = ntree)
)
