library(igraph)
library(netrw)
## Part a ##
nodes = 1000
graph <- random.graph.game(nodes, p = 0.01, directed = TRUE)

random_Walk <- netrw(graph, walker.num = 1000, damping = 0.85, T = 5000)
pagerank <- random_Walk$ave.visit.prob

hist(pagerank, freq = FALSE, xlab = "PageRank")

## Part b ##
nodes = 1000
graph <- random.graph.game(nodes, p = 0.01, directed = TRUE)
d <- degree(graph)
random_Walk <- netrw(graph, walker.num = 1000, damping = 0.85, T = 5000)
pagerank <- random_Walk$ave.visit.prob
teleport <- netrw(graph, walker.num = 1000, teleport.prob = pagerank, damping = 0.85, T = 5000)

tele_prob <- teleport$ave.visit.prob
rela <- cor(pagerank, tele_prob)
cat("Correlation between PageRank and PageRank with teleportation: ", rela)
hist(tele_prob,freq = FALSE)

plot(density(pagerank),col = "blue", xlab = "PageRank", main = "PageRank and personalized PageRank")
lines(density(tele_prob), col = "red")
legend("topright", c("Normal PageRank","Personalized PageRank"),lty=c(1,1),lwd=c(2.5,2.5),col=c("blue","red"))
## Part c ##
nodes = 1000
graph <- random.graph.game(nodes, p = 0.01, directed = TRUE)
d <- degree(graph)
random_Walk <- netrw(graph, walker.num = 1000, damping = 0.85, T = 5000)
pagerank_iter <- random_Walk$ave.visit.prob
plot(density(pagerank),col = "blue", main = "personalized PageRank", xlab = "PageRank")
iteration <- 10
for (i in 1:iteration) {
  teleport <- netrw(graph, walker.num = 1000, teleport.prob = pagerank_iter, damping = 0.85, T = 5000)
  pagerank_iter <- teleport$ave.visit.prob
  lines(density(pagerank_iter), col = "black")
}
lines(density(pagerank_iter), col = "red")

