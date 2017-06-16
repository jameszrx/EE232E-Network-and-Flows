library(igraph)
library(plyr)
library(data.table)

movie.rating <- fread("./project_2_data/movie_rating_clean.txt",header = F, drop = 2)
movie.rating.sorted <- movie.rating[order(V3, decreasing = T),]

write.table(movie.rating.sorted[1:200], "./project_2_data/top_100_movie.txt", sep="\t", quote = F,row.names = F, col.names = F)

