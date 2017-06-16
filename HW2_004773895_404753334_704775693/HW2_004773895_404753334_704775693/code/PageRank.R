library(igraph)
library(netrw)
## Part a ##
nodes = 1000
graph <- random.graph.game(nodes, p = 0.01, directed = FALSE)
deg <- degree(graph)

random_Walk <- netrw(graph, walker.num = 1000, T = 5000, damping = 1)
prob <- random_Walk$ave.visit.prob
rela <- cor(deg, prob)
cat("Correlation between degree and visit probability: ", rela)
plot(deg, prob, xlab = "Degree", ylab = "Visit Probability", main = "Relation Between Degree and Visit Probability")
lm <- lm(prob~deg)
abline(lm, col="red")

## Part b ##
nodes = 1000
graph <- random.graph.game(nodes, p = 0.01, directed = TRUE)
deg <- degree(graph)
inDeg <- degree(graph, mode = "in")
outDeg <- degree(graph, mode = "out")

random_Walk <- netrw(graph, walker.num = 1000, T = 5000, damping = 1)
prob <- random_Walk$ave.visit.prob

rela <- cor(deg, prob)
cat("Correlation between All degree and visit probability: ", rela)
inRela <- cor(inDeg, prob)
cat("Correlation between In degree and visit probability: ", inRela)
outRela <- cor(outDeg, prob)
cat("Correlation between Out degree and visit probability: ", outRela)

plot(deg, prob, xlab = "Degree", ylab = "Visit Probability", main = "Relation Between All Degree and Visit Probability")
plot(inDeg, prob, xlab = "Degree", ylab = "Visit Probability", main = "Relation Between In Degree and Visit Probability")
plot(outDeg, prob, xlab = "Degree", ylab = "Visit Probability", main = "Relation Between Out Degree and Visit Probability")

## Part c ##
nodes = 1000
graph <- random.graph.game(nodes, p = 0.01, directed = FALSE)
deg <- degree(graph)

random_Walk <- netrw(graph, walker.num = 1000, T = 5000, damping = 0.85)
prob <- random_Walk$ave.visit.prob
rela <- cor(deg, prob)
cat("Correlation between degree and visit probability: ", rela)
plot(deg, prob, xlab = "Degree", ylab = "Visit Probability", main = "Relation Between Degree and Visit Probability with teleportation")
lm <- lm(prob~deg)
abline(lm, col="red")
