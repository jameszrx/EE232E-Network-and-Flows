##########import the library
library("igraph")
library("ggplot2")
library("hash")
library("fit.models")
library("MASS")
##########load the data
edgelistFile <- "/Users/Aozhu/Desktop/facebook_combined.txt"

g <- read.graph(edgelistFile , directed=FALSE)

g = graph.edgelist(el=edges, directed=FALSE); 

###########Q1 part1 get the connectivity and diameter
is.connected(g)
diameter(g, directed = FALSE)
degree.distribution(g)
Degrees = degree(g)
###########Q1 part2 get the histogram of degrees and degree distribution
h1 = hist(Degrees, breaks=seq(0.0, by= 1 , length.out=max(Degrees)+1))       
data_frame = data.frame(x=h1$mids, y=h1$density)
plot(data_frame,main="Degree Distribution of Facebook Graph", xlab="Nodes", ylab="Degree Distribution",type="o")

models = list(
  lm(y ~ (1/x), data = data_frame),
  lm(y ~ log(x), data = data_frame),
  nls(y ~ I(1/x*a) + b*x, data = data_frame, start = list(a = 1, b = 1)),
  nls(y ~ (a + b*log(x)), data = data_frame,  start = setNames(coef(lm(y ~ log(x), data = data_frame)), c("a", "b"))),
  nls(y ~ (1/x*a)+b, data=data_frame, start = list(a=1,b=1),trace=T),
  nls(y ~ (exp^(a + b * x)), data=data_frame, start = list(a=0,b=0),trace=T)
)
ggplot(data_frame, aes(x, y)) + geom_point(size = 1) +
  geom_line(aes(x,fitted(models[[1]])),size = 1,colour = "blue") + 
  geom_line(aes(x,fitted(models[[2]])),size = 1, colour = "yellow") +
  geom_line(aes(x,fitted(models[[3]])),size = 1,  colour = "purple")+
  geom_line(aes(x,fitted(models[[4]])),size = 1,  colour = "red")+
  geom_line(aes(x,fitted(models[[5]])),size = 1,colour = "green") + 
  geom_line(aes(x,fitted(models[[6]])),size = 1, colour = "white") +
  ggtitle("Fitted curve of different models")+ xlab("Nodes") +ylab("Degree Distribution")
summary(models[[6]])
mean(degree(g))

############Q2

nID1 = neighborhood(g, order = 1, nodes = 1)
pn1 = induced_subgraph(g, vids = unlist(nID1), impl = "auto")
pn1$names = sort(unlist(nID1))
cat("Number of nodes :" , vcount(pn1))
cat("Number of edges :", ecount(pn1)) 
ncolor = rep("green",vcount(pn1))
nsize = rep(2, vcount(pn1))
ncolor[pn1$names == 1] = "blue"
nsize[pn1$names == 1] = 2
plot(pn1 , vertex.size = nsize, vertex.color=ncolor , vertex.label=NA , asp=9/16, layout = layout.fruchterman.reingold)


