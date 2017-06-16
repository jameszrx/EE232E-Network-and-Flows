library(igraph)

iteration = 2000
num = 1000
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

#part a
h = hist(deg, breaks = seq(0, to = max(deg) + 1, by = 1), freq = FALSE, main = "Histogram of degree distribution with 1000 nodes", 
         xlab = "Degree")
p = data.frame(x = h$mids, y = h$density)
plot(p, type = "o", main = "Degree Distribution with 1000 nodes", xlab = "Degree", ylab = "Density")
plot(p, type = "o", log = "xy", main = "Degree Distribution with 1000 nodes(log)", xlab = "Degree", ylab = "Density")

print(mean(d))

#part b
con <- is.connected(g)
print(con)
hist(fg$membership, breaks = 50)
com_membership <- membership(fg)
md <- modularity(fg)
print(md)


