# bigmemoryの利用サンプル
# 大規模な行列の保持、分析を実行可能

# サンプルファイル作成
data(cars)
write.csv(cars, "./src/cars.csv", row.names = FALSE, quote = FALSE)

library(bigmemory, quietly = TRUE)
# データのバイナリファイルとそのメタ情報を保持するディスクリプタファイルを指定する
cars.bm <- read.big.matrix("./src/cars.csv", header = TRUE, type = "double",
                           backingpath = ".", backingfile = "cars.bin", descriptorfile = "cars.desc")

# matrixのようにアクセスできる
class(cars.bm)
dim(cars.bm)
head(cars.bm)
cars.bm[1:3,1:2]

# big.matrix型への集計
library(bigtabulate, quietly = TRUE)

# ディスクリプタファイルからデータロード
cars.bm <- attach.big.matrix("cars.desc")

# クロス集計
bigtable(cars.bm, ccols = c(1,2))

