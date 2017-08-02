nc <- 10000;  # 列数
nr <- 10000;  # 行数

# 行列 + apply 版
start <- proc.time()

m <- matrix(1, nr, nc)  # 行列

s <- apply(m, 2, sum)  # 各列について、sum を実行

print(proc.time() - start)     # 経過時間を出力

# 行列 + for ループ 版
start <- proc.time()

m <- matrix(1, nr, nc)  # 行列

for (i in 1:nc) {        # 各列について
  s <- 0
  for (j in 1:nr) {    # 各行について
    s = s + m[j, i]  # 各要素にアクセス
  }
}
print(proc.time() - start)     # 経過時間を出力

# データフレーム + lapply 版
start <- proc.time()

m <- data.frame( matrix(1, nr, nc) )  # データフレーム

s <- lapply(m,  sum)  # 各列について、sum を実行

print(proc.time() - start)     # 経過時間を出力

# データフレーム + for ループ 版
start <- proc.time()

m <- data.frame( matrix(1, nr, nc) )  # データフレーム

for (i in 1:nc) {        # 各列について
  s <- 0
  for (j in 1:nr) {    # 各行について
    s = s + m[j, i]  # 各要素にアクセス
  }
}

print(proc.time() - start)     # 経過時間を出力