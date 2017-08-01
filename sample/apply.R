library('data.table')

temperature <- fread('temperature_1.txt', header = TRUE)

temperature

# 行方向(MARGIN=1)の平均
daily.means <- apply(temperature, 1, mean)

daily.means

# 列方向(MARGIN=2)の平均
site.means <- apply(temperature, 2, mean)
site.means


# 行方向の範囲
daily.ranges <- apply(temperature, 1, range)
daily.ranges

# 列方向の範囲
site.ranges <- apply(temperature, 2, range)
site.ranges


# applyに渡す関数にオプションを指定する
# 33行目から42行目まで、Site01 の値が -999なのでそこはNaにする
temperature2 <- fread('temperature_2.txt', header = TRUE, na.strings = '-999')

# apply に渡す関数にオプション指定をしたい場合、apply に渡す引数として、関数の後に続けて書く
# この場合は、na.rmをmeanに渡す引数としている
site.means2 <- apply(temperature2, 2, mean, na.rm = TRUE)

site.means2


# 自分で定義した関数を使う
# 最大と最少の差を計算する関数を定義
range.width <- function(x) {return (max(x) - min(x))}

# ３地点それぞれでの、年間の最暑日、最寒日の日平均気温の差
annual.dif <- apply(temperature, 2, range.width)
annual.dif

