library(igraph)
library(netrw)
nodeNum = c(100, 10000)
walkNum = c(100, 100)
for (n in 1:2) {
  g <- barabasi.game(nodeNum[n], direct = FALSE)
  avg = numeric()
  std = numeric()
  for (i in 1:100) {
    dists = numeric()
    rw <- netrw(g, walker.num = walkNum[n], damping = 1, T = i, output.walk.path = TRUE)
    paths = rw$walk.path
    for (j in 1:walkNum[n]) {
      dist = shortest.paths(g, v = paths[1, j], to = paths[i, j])
      if (dist == Inf) 
        dist = 0
      dists = c(dists, dist)
    }
    avg = c(avg, mean(dists))
    std = c(std, sd(dists))
  }
  if (n == 1) {
    plot(avg, main = "average distance (100 nodes)", type = "b", xlab = "step size", ylab = "avg")
    plot(std, main = "standard deviation (100 nodes)", type = "b", xlab = "step size", ylab = "std")
    print(diameter(g));
  } else {
    plot(avg, main = "average distance (10000 nodes)", type = "b", xlab = "step size", ylab = "avg")
    plot(std, main = "standard deviation (10000 nodes)", type = "b", xlab = "step size", ylab = "std")
    print(diameter(g));
  }
}