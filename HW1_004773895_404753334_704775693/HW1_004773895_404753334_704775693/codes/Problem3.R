library("igraph")

### question 3 part A #####
nodes <- 1000
g <- aging.prefatt.game(nodes, pa.exp=1, aging.exp=-1, directed=FALSE)
degree_dist <- degree.distribution(g)
plot(seq(along=degree_dist)-1, degree_dist, log="xy",
     xlab="number of degree",
     ylab="Density",
     main="Degree Distribution for Evolving Graph")

### question 3 part B #####
fc <- fastgreedy.community(g)
modularity_graph <- modularity(fc)
plot(fc, g, vertex.label=NA, vertex.size=10, main = "Community Structure")

commumities_size <- sizes(fc)
density_commumities <- density(commumities_size)
plot(density_commumities, xlab = "Community Size", main="Community Size Distribution")

modularity_graph


