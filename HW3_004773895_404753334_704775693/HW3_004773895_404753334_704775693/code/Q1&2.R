library("igraph")
# load the data
file = scan("/Users/Aozhu/Desktop/sorted_directed_net.txt", what=list(0,0,0))   
out <- file[[1]] + 1
to <- file[[2]] + 1
edge = cbind(out, to)
g <- graph.edgelist(el=edge, directed=TRUE); 
E(g)$weight <- file[[3]];
# get the connectivity of the network
connectivity = is.connected(g)
connectivity  # return true or false
# find strong connected component
gcc <- clusters(g, mode="strong")
gccIndex = which.max(gcc$csize)
gccNode <- c()
for(i in 1:length(V(g))){
  if(gcc$membership[i] == gccIndex)
    gccNode <- append(gccNode, i)
}
out_strong <- degree(g,v=gccNode, mode="out")
in_strong <- degree(g,v=gccNode,mode="in")
# get degree distribution graph of in-degree and out-degree of the nodes
hist(in_strong, breaks = seq(from = min(in_strong), to = max(in_strong), by = 0.01), xlab = "Nodes", ylab = "In degree", main = " Degree distribution of in-degree")
hist(out_strong, breaks = seq(from = min(out_strong), to = max(out_strong), by = 0.01), xlab = "Nodes", ylab = "Out degree", main = " Degree distribution of out-degree")
