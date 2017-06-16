library(igraph)
library(data.table)

print("start reading data")
edges_list <- fread(input="C:/Users/James/Desktop/EE232/Project_2/edge_list_file_15actor_singletab.txt", sep = "\t", header = FALSE)


print("start constructing network")
movie_network <- graph.data.frame(edges_list, directed = FALSE)

print("assign weights to network")
E(movie_network)$weight <- cbind(unlist(edges_list[,V3]))

print("deleting used data object edges_list")
rm(edges_list)

print("find the 3 movies")

movie_to_find <- c("Batman v Superman: Dawn of Justice (2016)", "Mission: Impossible - Rogue Nation (2015)", "Minions (2015)")
top_neighbors <- {}

for(movie in movie_to_find){
  vertex_index <- which(V(movie_network)$name == movie)
  neighbors_edge_list <- E(movie_network)[from(vertex_index)]
  edge_weight <- E(movie_network)[neighbors_edge_list]$weight
  sorted_edge_weight <- sort.int(edge_weight, index.return = TRUE, decreasing = TRUE)
  top_5 <- sorted_edge_weight$ix[1:5]
  top_neighbors[[movie]] <- neighbors_edge_list[top_5]
}

print(top_neighbors)