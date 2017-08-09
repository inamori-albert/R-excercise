# ffの利用サンプル
# 大規模な行列の保持、分析を実行可能

# サンプルファイル作成
data(iris)
write.csv(iris, "./src/iris.csv", row.names = FALSE, quote = FALSE)

library(ff, quietly = TRUE)

# ファイルの読み込み
iris.ff <- read.csv.ffdf(file = "./src/iris.csv", header = TRUE)
# iris.ff <- read.table.ffdf(file = "./src/iris.csv", header = TRUE)

class(iris.ff)
iris.ff[1:3, 1:2]
# すべてのデータを読み込むのでおすすめしない
iris.ff[1:3, c("Sepal.Length","Sepal.Width")]
# $を使えば一部だけにアクセスできる
iris.ff$Sepal.Length[1:3]

# ffdf型に集計処理を行う
library(ffbase, quietly = TRUE)
table(iris.ff$Species)
