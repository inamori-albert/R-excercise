# tidyrの使い方サンプル
# data.frameを縦長・横長・入れ子に変形・整形するためのツール
# dplyrやpurrrと一緒に使うといいらしい
## 参考：https://heavywatal.github.io/rstats/tidyr.html


library(tidyr)
library(tibble)
library(dplyr)

# gather()を使って、縦長にする
# 整然データ化
iris %>% head(3L) %>% rownames_to_column('id') %>% 
  gather(kagi, atai, -id, -Species)


# spread()を使って、横長にする
iris %>% head(3L) %>% rownames_to_column('id') %>% 
  gather(kagi, atai, -id, -Species) %>%
  spread(kagi, atai)

# nest()を使って、data.frameをネスト[]して(入れ子にして)、list of data.frames のカラムを作る
# 内側のdata.frameに押し込むカラムを ... に指定するか、 外側に残すカラムをマイナス指定する
iris %>% nest(-Species, .key=NEW_COLUMN)

# separate()を使って、.でvariableの値を分ける
iris %>%
  tidyr::gather(variable, value, c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width)) %>%
  tidyr::separate(variable, into = c('Parts', 'Scale'), sep='\\.') %>% 
  head(5)

# extract()を使って、正規表現でグルーピングした値でvariableの値を分ける
iris %>%
  tidyr::gather(variable, value, c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width)) %>%
  tidyr::extract(variable, into = c('Parts', 'Scale'), regex='(.+)\\.(.+)') %>%
  head(5)

# unite()を使って、分割した列を結合
iris %>%
  tidyr::gather(variable, value, c(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width)) %>%
  tidyr::separate(variable, into = c('Parts', 'Scale'), sep='\\.') %>% 
  tidyr::unite('variable2', c(Parts, Scale), sep='.') %>%
  head(5)

# complete()を使って、指定した列の全ての組み合わせが登場するように、 指定しなかった列に欠損値NA(あるいは任意の値)を補完した行を挿入
df <- data_frame(
  group = c(1:2, 1),
  item_id = c(1:2, 2),
  item_name = c("a", "b", "b"),
  value1 = 1:3,
  value2 = 4:6
) %>% complete(group, item_id)
