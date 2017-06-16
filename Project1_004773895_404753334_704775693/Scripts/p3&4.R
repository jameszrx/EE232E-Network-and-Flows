library(igraph)

text = read.table("facebook_combined.txt")
network = graph_from_data_frame(text,directed=FALSE)
degree <- degree(network)

core_nodes <- which(neighborhood.size(network, 1) > 201)
cat('There are',length(core_nodes),'core nodes')

core_degree_avg <- mean(degree[core_nodes])
cat('The average degree of these core nodes is', core_degree_avg)

node <- V(network)[core_nodes[23]]
personal_network <- graph.neighborhood(network, 1, node)[[1]]
V(personal_network)$size <- 5
V(personal_network)$color <- 'cornflowerblue'
edge_color = rep("grey", length(E(personal_network)))
edge_weight = rep(0.5, length(E(personal_network)))

core_idx <- which(V(personal_network)$name == node$name)
V(personal_network)[core_idx]$size <- 8
V(personal_network)[core_idx]$color <- 'red'
plot(personal_network,vertex.label=NA)

fastgreedy <- fastgreedy.community(personal_network)
plot(fastgreedy, personal_network, vertex.label=NA,edge.width = edge_weight, edge.color =  edge_color, main = "Community Structure")
sizes(fastgreedy)

Edge_Betweenness <- edge.betweenness.community(personal_network)
plot(Edge_Betweenness, personal_network, vertex.label=NA,edge.width = edge_weight, edge.color =  edge_color, main = "Community Structure")
sizes(Edge_Betweenness)

Infomap <- infomap.community(personal_network)
plot(Infomap, personal_network, vertex.label=NA,edge.width = edge_weight, edge.color =  edge_color, main = "Community Structure")
sizes(Infomap)

# question 4
personal_network_without_core <- delete.vertices(personal_network, V(personal_network)[core_idx])
plot(personal_network_without_core,vertex.label=NA)
V(personal_network_without_core)$size <- 5
V(personal_network_without_core)$color <- 'cornflowerblue'
edge_color = rep("grey", length(E(personal_network_without_core)))
edge_weight = rep(0.5, length(E(personal_network_without_core)))

fastgreedy_no_core <- fastgreedy.community(personal_network_without_core)
plot(fastgreedy_no_core, personal_network_without_core, vertex.label=NA,edge.width = edge_weight, edge.color =  edge_color, main = "Community Structure")
sizes(fastgreedy_no_core)

Edge_Betweenness_no_core <- edge.betweenness.community(personal_network_without_core)
plot(Edge_Betweenness_no_core, personal_network_without_core, vertex.label=NA,edge.width = edge_weight, edge.color =  edge_color, main = "Community Structure")
sizes(Edge_Betweenness_no_core)

Infomap_no_core <- infomap.community(personal_network_without_core)
plot(Infomap_no_core, personal_network_without_core, vertex.label=NA,edge.width = edge_weight, edge.color =  edge_color, main = "Community Structure")
sizes(Infomap_no_core)
