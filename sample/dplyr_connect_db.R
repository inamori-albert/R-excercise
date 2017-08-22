# dplyrでDB上のデータに接続するサンプル

library(dplyr)
library(RPostgreSQL)

# DBへの接続準備
my_db <- src_postgres(dbname="mydb",
                      host = "localhost",
                      port = "5432",
                      user = "postgres",
                      password = "hoge")

rstudiolog_postgres <- tbl(my_db, "rstudiolog")


# クエリの作成
q <- rstudiolog_postgres %.%
  group_by(package) %.%
  summarise(count=n()) %.%
  filter(count>10 & !is.na(package)) %.%
  arrange(desc(count))


# 性能確認(実行計画)
explain(q)


# クエリ実行によるデータ取得
collect(q)