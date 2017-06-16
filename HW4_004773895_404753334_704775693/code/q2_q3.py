import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import random
# import plotly.plotly as py

from igraph import *
from matplotlib.ticker import FuncFormatter

print "loading stock-return"
pij = pd.read_csv('./Temp/p_i_j.csv', header = 0, index_col=0)
symbols = list(pij)

pij = pij.as_matrix()

print "Calculating dij adjacency matrix"
dij = ((1 - pij)*2)**0.5
dij_no_diag = list()
for i in xrange(0,len(symbols)):
	for j in xrange(0,len(symbols)):
		if i != j:
			dij_no_diag.append(dij[i][j])

plt.hist(dij_no_diag,bins='auto')
plt.title("Histogram")
# To plot correct percentages in the y axis     
# to_percentage = lambda y, pos: str(round( ( y / float(len(dij_no_diag)) ) * 100.0, 2)) + '%'
# plt.gca().yaxis.set_major_formatter(FuncFormatter(to_percentage))
plt.savefig("./Graphs/hist")

# plot_url = py.plot_mpl(fig, filename='hist')

print "Constructing correlation graph based on adjacency matrix"
g = Graph.Weighted_Adjacency(dij.tolist(),loops = False,mode="undirected")
g.vs["name"] = symbols
print len(g.vs)
print len(g.es)
# print g

print "Finding Minimum Spanning Trees"
mst = Graph.spanning_tree(g, weights = g.es["weight"], return_tree=True)
layout = mst.layout("kk")
visual_style = {}
visual_style["vertex_size"] = 10
visual_style["vertex_color"] = 'blue'
visual_style["layout"] = layout
plot(mst, "./Graphs/mst_not_colored.png",**visual_style)

print "Plotting Minimum Spanning Trees"
layout = mst.layout("kk")
name_sectors_pair = pd.read_csv('./finance_data/Name_sector.csv')
sectors = name_sectors_pair.Sector.unique()
name_sectors_pair_dict = name_sectors_pair.set_index('Symbol').to_dict()

color_dict = {}
for s in sectors:
	color_dict[s] = '#{:02x}{:02x}{:02x}'.format(*map(lambda x: random.randint(0, 255), range(5)))

visual_style = {}
visual_style["vertex_size"] = 10
visual_style["vertex_color"] = [color_dict[name_sectors_pair_dict['Sector'][s]] for s in mst.vs["name"]]
visual_style["layout"] = layout
plot(mst, "./Graphs/mst.png",**visual_style)