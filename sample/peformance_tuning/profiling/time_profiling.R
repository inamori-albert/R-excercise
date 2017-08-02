# 実行時間のプロファイリング方法

set.seed(71)

# 一様乱数
x <- runif(1e7)

# 時間の計測
system.time(x^2)

# 時間の計測
# マイクロベンチマーキングができる
library("microbenchmark")
# 100回実行したときの処理時間
microbenchmark(x^2, times = 100)

# ２つの処理の実行時間の比較
benchmark_result <- microbenchmark(
  {res1 <- x^2},
  {res2 <- numeric(100000); for(i in 1:100000){res2 <- x[i]^2}}
)
plot(benchmark_result)

# 個々の処理の実行時間を測定
data(cars)
Rprof("cars.lm.out")
invisible(replicate(5000, lm(dist ~ speed, data = cars)))
Rprof(NULL)

dat <- summaryRprof("cars.lm.out")
names(dat)
# by.self:関数の実行に要した時間、他の関数の呼び出し時間は除く
# by.total:関数全体で処理した時間、他の関数の呼び出し時間を含む
# sample.interval:サンプリング間隔
# sampling.time:サンプリングに要した時間

head(dat$by.self)
head(dat$by.total)

# プロファイルの可視化
library("profr")
plot(parse_rprof("cars.lm.out"), main="Profiled of lm()")

# 他にもlineprofで行ごとにプロファイリングと可視化ができる
