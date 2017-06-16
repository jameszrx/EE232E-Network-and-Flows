library(igraph)
library(stringr)
library(data.table)
library(plyr) 

print("start reading data")
edges_list <- fread(input="C:/Users/James/Desktop/EE232/Project_2/edge_list_file_15actor_singletab.txt", sep = "\t", header = FALSE)


print("start constructing network")
movie_network <- graph.data.frame(edges_list, directed = FALSE)

print("assign weights to network")
E(movie_network)$weight <- cbind(unlist(edges_list[,V3]))

print("deleting used data object edges_list")
rm(edges_list)

print("finding community structure")
commu_mv <- fastgreedy.community(movie_network)
print(length(commu_mv))
comm_size <- sizes(commu_mv)
print(commu_size)
print(modularity(commu_mv))


for (i in 1:vcount(g)){
  movie_name = str_trim(V(g)$name[i])
  if (movie_name %in% movie_rating$V1){
    rating <- movie_rating$V2[which(movie_rating$V1 == movie_name)]
  }else{
    rating <- 0
  }
  rating_list <- rbind(rating_list,rating)
}

mov_list <- c("Batman v Superman: Dawn of Justice (2016)" ,"Mission: Impossible - Rogue Nation (2015)" ,"Minions (2015)")
weight_list = {}
neighbor_list = {}

mov_list <- str_trim(mov_list)
movie_in_graph <- str_trim(V(g)$name)
prediction_of_rating_list <- c()
for(movie in mov_list){
  tmp_ind <- which(movie_in_graph == movie)
  neighbor_list <- str_trim(neighbors(movie_network,tmp_ind)$name)
  index <- c()
  for (i in 1:length(neighbor_list)){
    if(neighbor_list[i] %in% movie_rating$V1 ){
      index[i] <- which(movie_in_graph == neighbor_list[i])
    }
  }
  rating_movie_neighbor <- rating_list[index]
  rating_movie_neighbor <- rating_movie_neighbor[is.finite(rating_movie_neighbor)] 
  rating_pred_i <- mean(rating_movie_neighbor)
  prediction_of_rating_list <- append(prediction_of_rating_list,rating_pred_i)
}
