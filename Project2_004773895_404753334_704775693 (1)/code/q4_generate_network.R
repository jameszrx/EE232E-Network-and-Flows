library(igraph)
library(data.table)

print("start reading data")
edges_list <- fread(input="C:/Users/James/Desktop/EE232/Project_2/edge_list_file_10actor_singletab.txt", sep = "\t", header = FALSE)

print("start constructing network")
movie_network <- graph.data.frame(edges_list, directed = FALSE)

print("assign weights to network")
E(movie_network)$weight <- cbind(unlist(edges_list[,3]))

print("save network as Rdata")
save(movie_network, file = "C:/Users/James/Desktop/EE232/Project_2/q4_network_object.Rdata")


