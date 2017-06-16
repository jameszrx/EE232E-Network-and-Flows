library("igraph")
p <- c(0.01,0.05,0.1)
#Part(a)
# create random graph
g1 <- random.graph.game(1000.0, p[1], directed=F);
g2 <- random.graph.game(1000.0, p[2], directed=F);
g3 <- random.graph.game(1000.0, p[3], directed=F);


degreesVector1 <- degree(g1)
degreesVector2 <- degree(g2)
degreesVector3 <- degree(g3)

##PLOT THE DEGREE DISTRIBUTION
h1 <- hist(degreesVector1, breaks=seq(-0.5, by=1 , length.out=max(degreesVector1)+2),main="Degree Distribution for G1 (with p=0.01)")
h2 <- hist(degreesVector2, breaks=seq(-0.5, by=1 , length.out=max(degreesVector2)+2),main="Degree Distribution for G2 (with p=0.05)")
h3 <- hist(degreesVector3, breaks=seq(-0.5, by=1 , length.out=max(degreesVector3)+2),main="Degree Distribution for G3 (with p=0.1)")

##PLOTTING THE DENSITY FUNCTIONS
pl1 <- data.frame(x=h1$mids, y=h1$density)
plot(pl1 , type="o", col="black",main="Degree distribution with p = 0.01",xlab="Degree",ylab="Density")
pl2 <- data.frame(x=h2$mids, y=h2$density)
plot(pl2 , type="o", col="black",main="Degree distribution with p = 0.05",xlab="Degree",ylab="Density")
pl3 <- data.frame(x=h3$mids, y=h3$density)
plot(pl3 , type="o", col="black",main="Degree distribution with p = 0.1",xlab="Degree",ylab="Density")

#Part(b)

## CHECKING THE CONNECTIVITY OF GRAPH G1 WITH p=0.01
if(is.connected(g1))
{
  print("Graph g1 with edge drawing probability p= 0.01 is connected.")
} else 
  print("Graph g1 with edge drawing probability p= 0.01 is NOT connected.")

## CHECKING TH CONNECTIVITY OF GRAPH G2 WITH p=0.05
if(is.connected(g2))
{
  print("Graph g2 with edge drawing probability p= 0.05 is connected.")
} else 
  print("Graph g2 with edge drawing probability p= 0.05 is NOT connected.")

## CHECKING TH CONNECTIVITY OF GRAPH G3 WITH p=0.1
if(is.connected(g3))
{
  print("Graph g3 with edge drawing probability p= 0.1 is connected.")
} else 
  print("Graph g3 with edge drawing probability p= 0.1 is NOT connected.")

##DIAMETERS OF THE THREE GRAPHS
dia1=diameter(g1, directed = FALSE, unconnected = FALSE, weights = NULL)
path1=get.diameter(g1, directed = FALSE, unconnected = FALSE, weights = NULL)
dia2=diameter(g2, directed = FALSE, unconnected = FALSE, weights = NULL)
path2=get.diameter(g2, directed = FALSE, unconnected = FALSE, weights = NULL)
dia3=diameter(g3, directed = FALSE, unconnected = FALSE, weights = NULL)
path3=get.diameter(g3, directed = FALSE, unconnected = FALSE, weights = NULL)
cat("Diameter of graph G1 is: ",dia1,"and a path with this diameter is: ",path1,'\n' )
cat("Diameter of graph G2 is: ",dia2,"and a path with this diameter is: ",path2,'\n' )
cat("Diameter of graph G3 is: ",dia3,"and a path with this diameter is: ",path3 ,'\n')


#Part(c) FINDING THRESHOLD 'p'
prob_th=0.0000
repeat{
  g <- random.graph.game(1000, prob_th, directed=F);
  if(is.connected(g))
  {
    cat("The threshold probability p = ",prob_th)
    break()
  }else
  {
    cat(prob_th,'\n')
    prob_th <- prob_th+0.0005
  }
}

