# aws.s3パッケージによる、RからAWS S3の操作
# 参考：http://blog.hoxo-m.com/2017/07/18/aws_s3_intro/


library(aws.s3)


# アカウントとの紐付け
## 環境変数の値を確認
Sys.getenv("AWS_DEFAULT_REGION")

Sys.setenv("AWS_DEFAULT_REGION" = "<リージョン>", # us-east-2 など
           "AWS_ACCESS_KEY_ID" = "<アクセスキーID>",
           "AWS_SECRET_ACCESS_KEY" = "<シークレットキー>")


## defaultのアカウント情報を用いた署名
aws.signature::use_credentials()

## ユーザのアカウント情報を利用する場合
aws.signature::use_credentials(profile = "useruri")


# オブジェクトの操作
## Rオブジェクト(.Rdata, .rds)の読み書き (s3save(), s3saveRDS())
## R関数を使ったRへの読み書き (s3read_using(), s3write_using())
## ローカルファイルのバケットへの保存 (put_object())
## バケットからのローカルへの保存 (get_object())
## バケット、オブジェクトの削除 (delete_bucket(), delete_object())

## バケットの一覧を表示
bucketlist()

## バケットの中身を取得
get_bucket("aws.s3.testbucket")
