library(igraph) 
library(netrw)

random_walker_func = function(node){
  random_network <- barabasi.game(n = node, directed = FALSE)
  cat("Diameter of network with", node, "nodes = ", diameter(random_network))
  
  average_step_t = numeric()
  average_standard_deviation_t = numeric()
  distance_matrix = shortest.paths(random_network, v = V(random_network), to = V(random_network))
  deg_random_walk = numeric()
  
  for (t in 1:50) {
    
    distance = numeric()
    vertex_sequence = netrw(random_network, walker.num = node, damping = 1, T = t, output.walk.path = TRUE)$walk.path # get vertex sequence of random walk
    
    for(n in (1:node))
    {
      start_vertex = vertex_sequence[1,n]
      tail_vertex = vertex_sequence[t,n]
      shortest_distance = distance_matrix[start_vertex, tail_vertex]
      # shortest_distance = get.shortest.paths(random_network, from = vertex_sequence[1,n], to = vertex_sequence[t,n])
      if (shortest_distance == Inf) {
        shortest_distance = 0
      }
      distance = c(distance, shortest_distance)
      deg_random_walk = c(deg_random_walk, degree(random_network, v = tail_vertex))  
    }
    
    average_step_t = c(average_step_t, mean(distance))
    average_standard_deviation_t = c(average_standard_deviation_t, mean((distance - mean(distance))**2))
  }
  
  plot(average_step_t, type='l', main = paste("Average Steps vs. t - ", n, "nodes"), xlab = "t", ylab = "Average Steps")
  plot(average_standard_deviation_t, type='l', main = paste("Average Standard Deviation vs. t - ", n, "nodes"), xlab = "t", ylab = "Average Standard Deviation")
  

  cat("Executing for Random Network with 1000 nodes")
  random_walker_func(node = 1000)  

  deg_network = degree(random_network)
  hist(x = deg_network, breaks = seq(from = min(deg_network), to = max(deg_network), by=1), main = "Degree Distribution - Random Undirected Graph (1000 nodes)", xlab = "Number of Degrees")
  hist(x = deg_random_walk, breaks = seq(from = min(deg_random_walk), to = max(deg_random_walk), by=1), main = "Degree Distribution at end of Random Walk", xlab = "Number of Degrees")
}
