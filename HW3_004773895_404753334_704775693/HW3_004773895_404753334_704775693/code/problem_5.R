library(igraph)

graph <- read.table("sorted_directed_net.txt", sep = "\t", header = FALSE)
colnames(graph) <- c("Node1", "Node2", "weights")
network <- graph.data.frame(graph, directed = TRUE)

# get gcc
clusters <- clusters(network)
index_GCC <- which.max(clusters$csize)
GCC = delete.vertices(network, (1:vcount(network))[clusters$membership != index_GCC])

graph_undirected <- as.undirected(GCC, mode = "collapse", edge.attr.comb = function(x) sqrt(prod(x)))
communities <- fastgreedy.community(graph_undirected, weights = E(graph_undirected)$weights)

# question 5
communities_larger_than_100 <- which(sizes(communities) > 100)
subcommunities_sizes <- c()
subcommunities_modularities <- c()
for (i in 1:length(communities_larger_than_100)) {
  subCom_network <- delete.vertices(graph_undirected, (1:vcount(graph_undirected))[communities$membership != communities_larger_than_100[i]])
  sub_Communities <- fastgreedy.community(subCom_network, weights = E(subCom_network)$weights) # change to label.propagation.community latter
  subcommunities_sizes[[i]] <- sizes(sub_Communities)
  subcommunities_modularities[[i]] <- modularity(sub_Communities)
  plot(sub_Communities, subCom_network, vertex.label=NA, vertex.size=10, main = "Community Structure")
}
subcommunities_sizes
subcommunities_modularities

