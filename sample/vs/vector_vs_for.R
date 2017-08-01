# 逐次処理とベクトル処理のパフォーマンス比較
# 参考：http://takenaka-akio.org/etc/benchmark/
# R版 （ベクトル処理）

start <- proc.time()

rep <- 5000   # 足し算の回数
n   <- 5000   # 変数の数（配列の要素数）

x <- rep(0, n)  # 一万個の変数（配列）の初期化

for (j in (1:rep) ) {   # rep 回の繰り返し
  # 一万個の変数に、一度に値を加える
  x <- x + (1:n)   # 数値計算ライブラリのテストでは、x <- x + log(1:n)
}

print(proc.time() - start)

# R版 （要素逐次処理）

start <- proc.time()

rep <- 5000   # 足し算の回数
n   <- 5000   # 変数の数（配列の要素数）

x <- rep(0, n)  # 一万個の変数（配列）の初期化

for (j in (1:rep) ) {    # rep 回の繰り返し
  for (i in (1:n)) {   # 一万個の変数それぞれに値を加える
    x[i] <- x[i] + i   # 数値計算ライブラリのテストでは、x[i] <- x[i] + log(i + 1)
  }
}

print(proc.time() - start)     # 経過時間を出力