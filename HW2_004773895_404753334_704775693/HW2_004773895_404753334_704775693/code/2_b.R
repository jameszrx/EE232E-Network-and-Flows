library(igraph)
library(netrw)
avg = numeric()
std = numeric()
nodeNum = 1000
walkNum = 400
g <- barabasi.game(nodeNum, directed = FALSE)
for (i in 1:100) {
  dists = numeric()
  rw <- netrw(g, walker.num = walkNum, damping = 1, T = i, output.walk.path = TRUE)
  paths = rw$walk.path
  for (j in 1:walkNum) {
    dist = shortest.paths(g, v = paths[1, j], to = paths[i, j])
    if (dist == Inf) 
      dist = 0
    dists = c(dists, dist)
  }
  avg = c(avg, mean(dists))
  std = c(std, sd(dists))
}
plot(avg, main = "average distance (1000 nodes)", type = "b", xlab = "step size", ylab = "avg")
plot(std, main = "standard deviation (1000 nodes)", type = "b", xlab = "step size", ylab = "std")


