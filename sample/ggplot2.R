# ggplot2による可視化のサンプル
# 参考：https://heavywatal.github.io/rstats/ggplot2.html


library(ggplot2)


# データと全体設定を持つggplotオブジェクトの作成
gp <- ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species))

## グラフのレイヤーを重ねる
# 散布図
gp <- gp + geom_point(size=3, alpha=0.7)

# 描画
print(gp)

## さらにグラフを重ねたり、タイトルやテーマの設定をしたり
gp = gp + geom_smooth(method=glm, method.args=list(family=gaussian))
gp = gp + labs(title="Iris Sepal")
gp = gp + theme_bw()
gp = gp + theme(panel.grid.minor=element_blank())
print(gp)

## ファイルに保存
ggsave("iris_sepal.png", gp)

# グラフの描画
# 散布図
gp0 <- ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species))
gp <- gp0 + geom_point(size=3, alpha=0.7)
print(gp)

# 折れ線(データ順に並ぶ)
gp <- gp0 + geom_path(size=2, linetype="dashed")
print(gp)

# 折れ線(x軸上の順で並ぶ)
gp <- gp0 + geom_line()
print(gp)

# 折れ線(階段状に結ぶ)
gp <- gp0 + geom_step() 
print(gp)

# ヒストグラム、密度曲線(棒グラフ(連続値をstat_bin() で切って))
gp0 <- ggplot(iris, aes(x=Sepal.Length))
gp <- gp0 + geom_histogram(aes(fill=Species))
print(gp)

# 棒グラフ
gp <- gp0 + geom_bar(aes(fill=Species))
print(gp)

# 折れ線
gp <- gp0 + geom_freqpoly()
print(gp)




