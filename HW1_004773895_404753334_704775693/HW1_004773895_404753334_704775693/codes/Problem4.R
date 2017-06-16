library("igraph")

iteration = 500
indeg = numeric()
outdeg = numeric()
### question 4 part A #####
for (i in 1:iteration) {
  graph <- forest.fire.game(1000, fw.prob=0.37, bw.factor=0.32/0.37, directed = TRUE)
  indeg <- c(indeg, degree(graph, mode = "in"))
  outdeg <- c(outdeg, degree(graph, mode = "out"))
}

## in degree ##
indeg.hist.freq <- hist(indeg, breaks = seq(from = 0, to = max(indeg) + 1, by = 1), 
                   freq = TRUE, main = "Histogram of in degree distribution with 1000 nodes",
                   xlab = "Number of Degree")
indeg.hist <- hist(indeg, breaks = seq(from = 0, to = max(indeg) + 1, by = 1), 
                   freq = FALSE, main = "Histogram of in degree distribution with 1000 nodes",
                   xlab = "Number of Degree")
p1 = data.frame(x = indeg.hist$mids, y = indeg.hist$density)
plot(p1, main = "In degree distribution with 1000 nodes original", xlab = "Degree", ylab = "Density")
plot(p1, log = "y", main = "In degree distribution with 1000 nodes log y axis", xlab = "Degree", ylab = "Density")
plot(p1, log = "xy", main = "In degree distribution with 1000 nodes log x and y axis", xlab = "Degree", ylab = "Density")

## out degre ##
outdeg.hist.freq <- hist(outdeg, breaks = seq(from = 0, to = max(outdeg) + 1, by = 1), 
                        freq = TRUE, main = "Histogram of out degree distribution with 1000 nodes",
                        xlab = "Number of Degree")
outdeg.hist <- hist(outdeg, breaks = seq(from = 0, to = max(outdeg) + 1, by = 1), 
                   freq = FALSE, main = "Histogram of out degree distribution with 1000 nodes",
                   xlab = "Number of Degree")
p2 = data.frame(x = outdeg.hist$mids, y = outdeg.hist$density)
plot(p2, main = "out degree distribution with 1000 nodes original", xlab = "Degree", ylab = "Density")
plot(p2, log = "y", main = "out degree distribution with 1000 nodes log y axis", xlab = "Degree", ylab = "Density")
plot(p2, log = "xy", main = "out degree distribution with 1000 nodes log x and y axis", xlab = "Degree", ylab = "Density")

### question 4 part B and C #####
iteration = 50
nodes = 1000
d = numeric()
count = numeric()

for (i in 1:iteration) {
  g = forest.fire.game(nodes, fw.prob = 0.37, bw.factor = 0.32/0.37, directed = TRUE)
  d = c(d, diameter(g))
  ans = walktrap.community(g)
  count = c(count, modularity(ans))
}

plot(ans, g, vertex.label=NA, vertex.size=10, main = "Community Structure")
diameter <- mean(d)
modularity <- mean(count)

cat("Avg Diameter of Forest Fire Graphes of 50 iterations : ", diameter)
cat("Avg modularity of Forest Fire Graphes of 50 iterations : ", modularity)

