library(igraph)
library(data.table)
library(hashmap)

##########################################
print("start reading data")
edges_list <- fread(input="C:/Users/James/Desktop/EE232/Project_2/edge_list_file_80actor_singletab.txt", sep = "\t", header = FALSE)

print("reading genre data")
genre_data_frame <- fread(input="C:/Users/James/Desktop/EE232/Project_2/movie_genre_1tab.txt", sep = "\t", header = FALSE)

#print("constructing genre hashmap")
#genre_dict <- hashmap(as.list(genre_data_frame[V1]), as.list(genre_data_frame[V2]))

print("start constructing network")
movie_network <- graph.data.frame(edges_list, directed = FALSE)

print("assign weights to network")
E(movie_network)$weight <- cbind(unlist(edges_list[,V3]))
rm(edges_list)
##########################################

print("constructiong genre list")
genre_list <- c()
count = 1
movie_name <- ""
for (i in 1:vcount(movie_network)){
  #if(stri_enc_isutf8(V(movie_network)$name[i])){
  #movie_name = str_trim(V(network_mov_simp)$name[i])
  movie_name = V(movie_network)$name[i]
  #}
  
  if(movie_name %in% genre_data_frame$V1){
    curr_genre <- genre_data_frame$V2[which(genre_data_frame$V1 == movie_name)]
  } else {
    curr_genre <- "NA"
  }
  
  genre_list <- rbind(genre_list, curr_genre)
  count <- count + 1
}

##################################################

print("finding community structure")
commu_mv <- fastgreedy.community(movie_network)
print(length(commu_mv))
comm_size <- sizes(commu_mv)
print(commu_size)
print(modularity(commu_mv))

print("assign genre to communities")
genre_of_comm <- array(data = 0)
for(i in 1:length(commu_mv)){
  size_comm_i <- sizes(commu_mv)[i]
  genre_comm_i <- data.frame(genre_list[which(commu_mv$membership==i),1])
  colnames(genre_comm_i) <- "genre"
  genre_in_comm <- as.data.frame(table(genre_comm_i))
  rownames(genre_in_comm) <- genre_in_comm$genre_comm_i
  if (max(genre_in_comm$Freq) > 0.2*size_comm_i){
    index <- which((genre_in_comm$Freq==max(genre_in_comm$Freq)))[1]
    genre_of_comm[i] <-rownames(genre_in_comm[index,])
  }else{
    index <- which((genre_in_comm$Freq > 0.2*size_comm_i))[1]
    genre_of_comm[i] <-rownames(genre_in_comm[index,])
  }
}

print(genre_of_comm)

