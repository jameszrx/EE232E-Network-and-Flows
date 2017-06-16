library(igraph)
library(data.table)
edgesFile <- "./project_2_data/edge_list.txt"
edges <- fread(edgesFile,header=F)
vertices <- fread("./project_2_data/actor_actress_list.txt",header = F, sep = "\n")
vertices$name = vertices$V1
myvertices <- vertices[!duplicated(vertices), ]
network.actor <- graph.data.frame(edges, directed=TRUE, vertices = myvertices)
pagerank = page.rank(network.actor, directed = TRUE, damping = 0.85)
sorted.page.rank = sort(pagerank$vector, decreasing = TRUE, index.return = TRUE)

sorted.page.rank$x[1:10]
write.table(sorted.page.rank$x, "./project_2_data/pagerank.txt", sep="\t", quote = F, col.names = F)





