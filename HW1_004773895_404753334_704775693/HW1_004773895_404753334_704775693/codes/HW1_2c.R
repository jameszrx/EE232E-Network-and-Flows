library(igraph)
#Part c
iteration = 50
num = 10000
d = numeric()
deg = numeric()

for (i in 1:iteration) {
  g = barabasi.game(num, directed = FALSE)
  d = c(d, diameter(g))
  deg = c(deg, degree(g))
  clu = clusters(g)
  gcc_index = which.max(clu$csize)
  gcc_none = (1:vcount(g))[clu$membership != gcc_index]
  gcc <- delete.vertices(g, gcc_none)
  fg <- fastgreedy.community(gcc)
}

modu_fg = modularity(fg)
print(modu_fg)

h = hist(deg, breaks = seq(0, to = max(deg) + 1, by = 1), freq = FALSE, main = "Histogram of degree distribution with 1000 nodes", 
         xlab = "Degree")
p = data.frame(x = h$mids, y = h$density)
plot(p, type = "o", main = "Degree Distribution with 10000 nodes", xlab = "Degree", ylab = "Density")
plot(p, type = "o", log = "xy", main = "Degree Distribution with 10000 nodes(log)", xlab = "Degree", ylab = "Density")

print(mean(d))