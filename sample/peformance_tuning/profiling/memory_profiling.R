# 実行時のメモリ使用量のプロファイリング方法

# メモリ使用量の測定前に未使用のメモリ領域を開放
gc()

data(cars)

# オブジェクトのメモリサイズの確認方法
object.size(cars)
print(object.size(cars), unit = "Kb")

library("pryr")
object_size(cars)

# 実行時のメモリ使用量の測定
Rprof("cars.lm.out.mem", memory.profiling = TRUE)
invisible(replicate(5000, lm(dist ~ speed, data = cars)))
Rprof(NULL)
gctorture(FALSE)

# 関数実行時間とメモリ使用量の要約
# memoryで指定できるのはboth(各関数の実行時間とともにメモリ使用量を併記),tseries(時間の経過とともに使用されたメモリ使用量を併記),stats(メモリ使用量の統計量を表示)
dat.mem <- summaryRprof("cars.lm.out.mem", memory = "both")
head(dat.mem$by.self)

# メモリ使用量の合計サイズ
mem_used()

# オブジェクトの生成に伴うメモリ使用量の増加量
mem_change(z <- 1:1e6)

# オブジェクトの削除に伴うメモリ使用量の減少量
mem_change(rm(z))
