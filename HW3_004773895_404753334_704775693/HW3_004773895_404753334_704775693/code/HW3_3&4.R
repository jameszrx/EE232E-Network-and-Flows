library(igraph)
library(netrw)

#create the network
inputdata = read.table("/Users/James/Desktop/EE232/HW3/sorted_directed_net.txt", sep = "\t", header = FALSE)

colnames(inputdata) = c("node1", "node2", "weights")

diNetwork = graph.data.frame(inputdata, directed=TRUE)

connectivity = is.connected(diNetwork)
print(connectivity)

if(!connectivity){
  clusters = clusters(diNetwork)
  index = which.max(clusters$csize)
  otherNodes = (1:vcount(diNetwork))[clusters$membership != index]
  gcc = delete.vertices(diNetwork, otherNodes)
}

#####Question 3#####
#Convert to undirected graph
#option 1 
unNetwork_o1 = as.undirected(gcc, mode="each")
community_o1 = label.propagation.community(unNetwork_o1, weights = E(unNetwork_o1)$weights)
mod_o1 = modularity(community_o1)
size_o1 = sizes(community_o1)
print(mod_o1)
print(size_o1)

#option 2
sqrt_wt = function(weight) sqrt(prod(weight))
unNetwork_o2 = as.undirected(gcc, mode="collapse", edge.attr.comb = sqrt_wt)
community_o2a = label.propagation.community(unNetwork_o2, weights = E(unNetwork_o2)$weights)
mod_o2a = modularity(community_o2a)
size_o2a = sizes(community_o2a)
print(mod_o2a)
print(size_o2a)

community_o2b = fastgreedy.community(unNetwork_o2, weights = E(unNetwork_o2)$weights)
mod_o2b = modularity(community_o2b)
size_o2b = sizes(community_o2b)
print(mod_o2b)
print(size_o2b)

#####Question 4#####
index_2b = which.max(sizes(community_o2b))
otherNodes_2b = (1:vcount(unNetwork_o2))[community_o2b$membership != index_2b]
gcc_2b = delete.vertices(unNetwork_o2, otherNodes_2b)
community_q4 = fastgreedy.community(gcc_2b, weights = E(unNetwork_o2)$weights)
mod_q4 = modularity(community_q4)
size_q4 = sizes(community_q4)
print('********Answer for question 4********')
print(mod_q4)
print(size_q4)



