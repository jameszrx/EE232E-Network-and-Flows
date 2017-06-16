library(igraph)

num = 1000
iteration = 5000
deg = numeric()

for (it in 1:iteration) {
  g = barabasi.game(num, directed = FALSE)
  i = sample(1:num, 1)
  x = neighborhood(g, 1, i)
  y = c(x[[1]][-1])
  j = sample(y, 1)
  deg = c(deg, degree(g, j))
}

h <- hist(deg, breaks = seq(from = 0, to = max(deg) + 1, by = 1), freq = FALSE, main = "Histogram of degree distribution", xlab = "Degree")

p <- data.frame(x = h$mids, y = h$density)
plot(p, type = "o", xlim = range(1,70), main = "Degree Distribution with 1000 nodes", xlab = "Degree", ylab = "Density")
plot(p, type = "o", xlim = range(0.5,100), log="xy", main = "Degree Distribution with 1000 nodes (log)", xlab = "Degree", ylab = "Density")

print(mean(deg))