library(igraph)

graph <- read.table("sorted_directed_net.txt", sep = "\t", header = FALSE)
colnames(graph) <- c("Node1", "Node2", "weights")
network <- graph.data.frame(graph, directed = TRUE)

# get gcc
clusters <- clusters(network)
index_GCC <- which.max(clusters$csize)
GCC = delete.vertices(network, (1:vcount(network))[clusters$membership != index_GCC])

# option 1

graph_undirected_op1 <- as.undirected(GCC, mode = "each")
communities_lp_op1 <- label.propagation.community(graph_undirected_op1, weights = E(graph_undirected_op1)$weights)
sizes(communities_lp_op1)
# option 2
graph_undirected_op2 <- as.undirected(GCC, mode = "collapse", edge.attr.comb = function(x) sqrt(prod(x)))
communities_lp_op2 <- label.propagation.community(graph_undirected_op2, weights = E(graph_undirected_op2)$weights)
communities_fg <- fastgreedy.community(graph_undirected_op2, weights = E(graph_undirected_op2)$weights)

# question 6
library(netrw)
com_nodes_score <- c()
count <- 0
communities <- communities_lp_op2
for(i in 1:vcount(network)) {
  cat(i)
  teleportation_prob <- rep(0, vcount(network))
  teleportation_prob[i] = 1
  pageRank <- netrw(network, start.node = i, walker.num = 1, damping = 0.85, teleport.prob = teleportation_prob)
  prob <- pageRank$ave.visit.prob
  sort_prob <- sort(prob, decreasing = TRUE, index.return = TRUE)
  Mi <- rep(0, length(communities))
  
  for (j in 1:30) {
    mj <- rep(0, length(communities))
    index <- communities$membership[sort_prob$ix[j]]
    if (!is.na(index)) {
      mj[[index]] <- 1
    }
    Mi = Mi + sort_prob$x[j] * mj
  }
  com_nodes_score[[i]] <- Mi
}
for(i in 1:vcount(network)) {
  score <- com_nodes_score[[i]]
  num <- length(score[score > 0.5])
  if (num >= 2) {
    cat(i,"\n")
    cat(score,"\n")
  }
}


