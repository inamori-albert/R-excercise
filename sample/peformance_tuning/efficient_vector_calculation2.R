set.seed(71)

N <- 1e7
x <- runif(N)
y <- runif(N)

# 2つのベクトルの和
system.time({
 res <- rep(NA, N)
 for(i in 1:N){
   res[i] <- x[i] + y[i]
 }
})

system.time({
 res <- x + y 
})