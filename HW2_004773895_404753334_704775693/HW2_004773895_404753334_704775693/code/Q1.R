library(igraph) 
library(netrw)

  randomWalker = function(node, probability){

  random_network = random.graph.game(n = node, p = probability, directed = FALSE)
  cat("Diameter of network with", node, "nodes = ", diameter(random_network))
  
  average_step_t = numeric()
  average_standard_deviation_t = numeric() 
  distance_matrix = shortest.paths(random_network, v = V(random_network), to = V(random_network))
  deg_random_walk = numeric()

  for (t in 1:35) {
    
    distance = numeric()
    vertex_sequence = netrw(random_network, walker.num = node, damping = 1, T = t, output.walk.path = TRUE)$walk.path # get vertex sequence of random walk
    
    for(n in (1:node))
    {
      start_vertex = vertex_sequence[1,n]
      tail_vertex = vertex_sequence[t,n]
      shortest_distance = distance_matrix[start_vertex, tail_vertex]
      if (shortest_distance == Inf) {
        shortest_distance = 0
      }
      distance = c(distance, shortest_distance)
      deg_random_walk = c(deg_random_walk, degree(random_network, v = tail_vertex))  
    }
  
    average_step_t = c(average_step_t, mean(distance))
    average_standard_deviation_t = c(average_standard_deviation_t, mean((distance - mean(distance))**2))
  }

  plot(average_step_t+1, type ='o', main = paste("<s(t)> v.s. t with ", n, "nodes"), xlab = "t(number of steps)", ylab = "<s(t)>Average distance")
  plot(average_standard_deviation_t, type ='o', main = paste("s^2(t) v.s. t with ", n, "nodes"), xlab = "t(number of steps)", ylab = "s^2(t)Standard Deviation")

  if (node == 1000) {
    deg_network = degree(random_network)
    hist(x = deg_network, breaks = seq(from = min(deg_network), to = max(deg_network), by=1), main = "Degree Distribution for Random Undirected Graph (with n=1000)", xlab = "Degrees")
    hist(x = deg_random_walk, breaks = seq(from = min(deg_random_walk), to = max(deg_random_walk), by=1), main = "Degree Distribution at end of Random Walk", xlab = "Degrees")
  }
}

cat("Executing for Random Network with 1000 nodes")
randomWalker(node = 1000, 0.01)

cat("Executing for Random Network with 100 nodes")
randomWalker(node = 100, 0.01)

cat("Executing for Random Network with 10000 nodes")
randomWalker(node = 10000, 0.01)

