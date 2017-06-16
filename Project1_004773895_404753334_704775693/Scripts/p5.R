library(igraph)
library(parallel)
library(foreach)
library(doParallel)

# Calculate the number of cores
no_cores <- detectCores() - 1

text = read.table("facebook_combined.txt")
network = graph_from_data_frame(text,directed=FALSE)

core_nodes <- V(network)[which(neighborhood.size(network, 1) > 201)]

mutual = function(network, core, node) {
  core_friends <- neighbors(network, core)
  node_friends <- neighbors(network, node)
  return(intersection(core_friends, node_friends))
}

embeddedness <- function(network, core, node) {
  return(length(mutual(network,core, node)))
}

dispersion <- function(network, core, node) {
  sub_network <- delete_vertices(network, c(core,node))
  mutual_friends <- mutual(network, core, node)
  dist <- distances(sub_network, v=mutual_friends$name, to=mutual_friends$name)
  dist[is.infinite(dist)]<-NA
  return(sum(dist,na.rm = TRUE)/2)
}

embd_all <- list()
disp_all <- list()

# Initiate cluster
registerDoParallel(no_cores)

for(core_name in core_nodes$name) {
  core <- V(network)[core_name]
  friends <- neighbors(network, core)
  cat(core$name,"\n")
  embd <- c()
  disp <- c()
  for(node in friends) {
    embd <- c(embd,embeddedness(network, core, node))
    disp <- c(disp, dispersion(network, V(network)[core], V(network)[node]))
  }

  embd_all <- list(embd_all, embd)
  disp_all <- list(disp_all, disp)
}

stopImplicitCluster()

em <- as.numeric(unlist(embd_all))
embd_density <- density(em)
h1<-hist(em,breaks = seq(from = 0, to = max(em) + 1, by = 1), main = "Histogram of embeddedness", xlab = "embeddedness", ylab = "frequency")
plot(embd_density,main="Distribution of embeddedness", xlab="embeddedness", ylab="density",pch=16)

disp <- as.numeric(unlist(disp_all))
disp_density <- density(disp)
h2<-hist(disp,main = "Histogram of dispersion", xlab = "dispersion", ylab = "frequency")
plot(disp_density,main="Distribution of dispersion",xlab="dispersion", ylab="density")

for(core_name in core_nodes[c(1,3,4)]) {
  cat(core_name)
  core <- V(network)[core_name]
  neighbor <- neighbors(network, core)
  max_dis_node <- NULL
  max_dis_val <- 0
  max_embd_node <- NULL
  max_embd_val <- 0
  max_disp_over_embd_node <- NULL
  max_disp_over_embd_val <- 0
  for(node in neighbor) {
    emb <- embeddedness(network, core, node)
    if(emb > max_embd_val) {
      max_embd_val <- emb
      max_embd_node <- V(network)[node]
    }
    dis <- dispersion(network, V(network)[core], V(network)[node])
    if(dis > max_dis_val) {
      max_dis_val <- dis
      max_dis_node <- V(network)[node]
    }
    if(emb > 0) {
      disp_over_embd <- dis/emb
      if(disp_over_embd > max_disp_over_embd_val) {
        max_disp_over_embd_val <- disp_over_embd
        max_disp_over_embd_node <- V(network)[node]
      }
    }
  }
  
  personal_network = graph.neighborhood(network, 1, core)[[1]]

  personal_community = fastgreedy.community(personal_network)
  sizes(personal_community)

  node_color = personal_community$membership+1
  node_size = rep(3,length(node_color))
  edge_color = rep("grey", length(E(personal_network)))
  edge_weight = rep(0.05, length(E(personal_network)))

  e_node_idx = which(V(personal_network)$name == max_embd_node$name)
  core_node_idx = which(V(personal_network)$name == core$name)
  d_node_idx = which(V(personal_network)$name == max_dis_node$name)
  ed_node_idx = which(V(personal_network)$name == max_disp_over_embd_node$name)

  edge_color[which(get.edgelist(personal_network, name = FALSE)[,1] == ed_node_idx | 
                     get.edgelist(personal_network, name = FALSE)[,2] == ed_node_idx)] = "red";
  edge_weight[which(get.edgelist(personal_network, name = FALSE)[,1] == ed_node_idx |  
                      get.edgelist(personal_network, name = FALSE)[,2] == ed_node_idx)] = 3;

  node_size[ed_node_idx] = 5
  node_color[ed_node_idx] = 7
  node_size[core_node_idx] = 4
  node_color[core_node_idx] = 0
  name_g <- paste('plot_',core_name,'.jpg', sep="")
  jpeg(name_g,width = 1920, height = 1080, units = "px", pointsize = 12, quality = 150)
  plot.igraph(personal_network, vertex.size = node_size , vertex.label = NA , edge.width = edge_weight, edge.color =  edge_color, vertex.color = node_color, asp=9/16, layout = layout.fruchterman.reingold)
  dev.off()
}








