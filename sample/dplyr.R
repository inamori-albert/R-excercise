# dplyrのサンプル
# data.frameに対して抽出(select, filter)、部分的変更(mutate)、要約(summarise)、ソート(arrange)などの処理を施すためのパッケージ
# purrr や tidyr と一緒に使うとよいらしい
## 参考1：https://heavywatal.github.io/rstats/dplyr.html
## 参考2：http://qiita.com/matsuou1/items/e995da273e3108e2338e
## |SQL | dplyr | R | 説明 |
## |where | filter | subset | 行の絞り込み|
## |count , max ,min等 | summarise | aggregate | 集計する|
## |group by | group_by | - | グルーピングする|
## |order by | arrange | sort , order | 行を並べ替える|
## |select | select | data[,c("a","b")] | データフレームから指定した列のみ抽出する|
## |(select句) | mutate | transform | 列の追加|


library(dplyr)
library(RcppRoll)

# データの読み込み
df <- read.table("./src/jyoukou_20141111.csv", sep = ",", header = T, fileEncoding="Shift-JIS")

# filterによる絞り込み
df %>% filter(駅名=='橋本駅') %>% head()
df %>% filter(駅名=='橋本駅' | 駅名=='古淵駅') %>% head()

# summariseによる集計
df %>% summarise(max_2013=max(X2013年), min_2013=min(X2013年), mean_2013=mean(X2013年))

# summarise_eachによる、指定した列への複数の関数による集計
# 列名は元の列名+function名となる
df %>% summarise_each(funs(max, min, mean), X2012年, X2013年)


# 列を選択する関数
## 関数	構文	説明
## starts_with	starts_with(x, ignore.case = TRUE)	列名がxで始まる列を取得。
## ends_with	ends_with(x, ignore.case = TRUE)	列名がxで終わる列を取得
## contains	contains(x, ignore.case = TRUE)	列名にxが含まれる列を取得
## matches	matches(x, ignore.case = TRUE)	正規表現xにマッチする列を取得
## num_range	num_range("x", 1:5, width = 2)	文字列xに連番を組み合わせた列を取得
## one_of	one_of("x", "y", "z")	x , y , zに含まれる変数を選択
## everything	everything()	すべての列を取得
# X200で始まる列毎のmaxとmin
df %>% summarise_each(funs(max, min), starts_with("X200"))


# グループ化
# 路線名のユニークな値毎のX2013の値のmax
df %>% group_by(路線名) %>% summarise(max=max(X2013年))

# add=Tとすることで複数条件でgroup byできる。(add=Fまたは指定しない場合はグループ情報が上書きされる)
df %>% group_by(駅名) %>% group_by(路線名, add=T) %>% summarise(max=max(X2013年))

# グループ情報の削除
# 複数グループ情報を指定した場合にグループ情報が残るため、全体にソートや関数を適用したい場合はグループ情報の削除を行う必要がある
df %>% group_by(駅名,路線名) %>% summarise(max=max(X2013年)) %>% arrange(路線名) # グループ情報が残っている
df %>% group_by(駅名,路線名) %>% summarise(max=max(X2013年)) %>% ungroup() %>% arrange(路線名) # グループ情報の削除済

# ソート
df %>% arrange(X1975年) # 昇順
df %>% arrange(desc(X1975年)) # 降順


# 列操作
## 列の選択
df %>% select(路線名, 駅名, X2013年) %>% head(10)

## 列名の変更
df %>% select(路線名, 駅名, X2013年) %>% rename(trainline=路線名)  %>% head(10)

## 列の追加
df %>% select(路線名, 駅名, X2013年) %>% mutate(times100=X2013年*100) %>% head(10)
df %>% select(路線名, 駅名, X2013年) %>% mutate(isover100000=ifelse(X2013年>100000,1,0)) %>% head(10)

# 結合

# Mutating joins	マッチした行の列を、元のdata.frameに追加
# inner_join	SELECT * FROM x JOIN y ON x.a = y.a
# left_join	SELECT * FROM x LEFT JOIN y ON x.a = y.a
# right_join	SELECT * FROM x RIGHT JOIN y ON x.a = y.a
# full_join	SELECT * FROM x FULL JOIN y ON x.a = y.a
# 路線名・駅名でinner_jon
df1 = read.csv("./src/jyoukou_20141111_1.csv", header = T)
df2 = read.csv("./src/jyoukou_20141111_2.csv", header = T)
df12 <- df1 %>% inner_join(df2, bY = c("路線名", "駅名"))

# Window関数
# ランキング
# 関数	説明
# row_number	昇順にランキングを付ける。同じ値がある場合は、最初に来た方を優先
# min_rank	昇順にランキングを付ける。同じ値がある場合は、同じ順位を付ける。gapあり
# dense_rank	昇順にランキングを付ける。同じ値がある場合は、同じ順位を付ける。gapなし
# percent_rank	min_rankを0～1にリスケールしたもの
# cume_dist	累積割合。percent_rankの累積和ではない。
# ntile	n個の群に分割する
# X2013年の値で昇順にランキング
df %>% select(路線名,駅名,X2013年) %>% mutate(row_num=row_number(X2013年)) %>% arrange(X2013年)
df %>% select(路線名,駅名,X2013年) %>% rename(trainline=路線名) %>% group_by(trainline) %>% mutate(row_num=row_number(X2013年)) %>% arrange(trainline,X2013年)

# Offset(lead,lag)
# 関数	説明
# lead	xを前方にnだけずらして、後方をdefaultで埋める
# lag	xを後方にnだけずらして、前方をdefaultで埋める
# 2つ前後のX2013年の値を新しい列として取る(default=0として欠損値NAは0で埋める。order_by=X2013年としてX2013年でソート順を指定する。)
df %>% select(路線名,駅名,X2013年) %>% mutate(lead=lead(X2013年, default=0, n=2, order_by=X2013年), lag=lag(X2013年, default=0, n=2, order_by=X2013年))

# 累積関数
data_frame(x = c(1,2,3,4,5)) %>%
  dplyr::mutate(cumsum=cumsum(x)) %>%
  dplyr::mutate(cummin=cummin(x)) %>%
  dplyr::mutate(cummax=cummax(x)) %>%
  dplyr::mutate(cummean=cummean(x))

data_frame(x = c(TRUE , TRUE ,  FALSE ,TRUE , TRUE)) %>%
  dplyr::mutate(cumall=cumall(x)) %>%
  dplyr::mutate(cumany=cumany(x))

# ローリング関数
# RcppRollを用いることで、指定ウィンドウサイズ内で集約関数を使用することができる
# 関数一覧
# 関数	説明
# roll_max	指定ウィンドウサイズ内の最大値を取得
# roll_min	指定ウィンドウサイズ内の最小値を取得
# roll_mean	指定ウィンドウサイズ内の平均値を取得
# roll_median	指定ウィンドウサイズ内の中央値を取得
# roll_sum	指定ウィンドウサイズ内の合計を取得
# roll_prod	指定ウィンドウサイズ内の総積を取得
# roll_var	指定ウィンドウサイズ内の分散を取得
# roll_sd	指定ウィンドウサイズ内の標準偏差を取得
#
# オプション一覧
# オプション	説明
# n	ウィンドウサイズ
# weights	ウィンドサイズと同じ長さのベクトルで、各要素の重みを指定します。
# fill	欠損値を何で埋めるかを指定します。
# align	ウインドウの位置を指定します。"left"、"center"、"right"が指定できます。
# normalize	重みをNormalizeするかどうかを指定します。
# na.rm	NAを削除するかどうかを指定します。

# 重み付き移動平均
data_frame(x = c(1:10) ) %>% dplyr::mutate(roll_mean=roll_mean(x , n=3 ,fill=NA))

# Window関数をfilterに使用
data_frame(x = c(1 , 2, 3, 4, 5) , y=c("aa" ,"aa" , "aa" , "bb" , "bb")) %>%
  dplyr::group_by(y) %>%
  dplyr::filter(min_rank(x) == 1)
