import pandas as pd
import numpy as np
import random

from igraph import *
from datetime import datetime
from dateutil.parser import parse

from collections import defaultdict
from math import log

print "extract the stock value"
df = pd.read_csv('./finance_data/Name_sector.csv')
symbols_full = df.Symbol.T.tolist()
symbols = list()
closing_price = defaultdict(list)

for name in symbols_full:
	file = "./finance_data/data/"+name+".csv"
	raw = pd.read_csv(file)
	if len(raw.Close.T.tolist()) < 765:
		continue
	symbols.append(name)
	raw['Weekday'] = pd.to_datetime(raw['Date']).apply(lambda x: x.weekday())
	raw = raw[raw.Weekday == 0]
	closing_price[name] = raw.Close.T.tolist()
# print len(symbols)
	# print closing_price

print "Calculating individual rij"
tau = 1
c = 0
length = len(symbols)
p = np.zeros((length,length))
r_list = list()
for i in xrange(0,length):
	r = np.array([])
	cp = closing_price[symbols[i]]
	for t in xrange(2,len(cp)):
		r = np.append(r, log(cp[t]) - log(cp[t-tau]))
	r_list.append(r)

print "Calculating pij for node i and j"
for i in xrange(0,length):
	for j in xrange(0,length):
		if i != j:
			ri = r_list[i]
			rj = r_list[j]
			p[i][j] = (np.mean(ri*rj)-np.mean(ri)*np.mean(rj))/((np.mean(ri**2)-np.mean(ri)**2)*(np.mean(rj**2)-np.mean(rj)**2))**0.5

pij = pd.DataFrame(data = p, index = symbols, columns = symbols)
pij.to_csv('./Temp/p_i_j_weekly.csv')
pij = pij.as_matrix()

print "Calculating dij adjacency matrix"
dij = ((1 - pij)*2)**0.5

print "Constructing correlation graph based on adjacency matrix"
g = Graph.Weighted_Adjacency(dij.tolist(),loops = False,mode="undirected")
g.vs["name"] = symbols
# print g

print "Finding Minimum Spanning Trees"
mst = Graph.spanning_tree(g, weights = g.es["weight"], return_tree=True)

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
plot(mst, "./Graphs/mst_weekly.png",**visual_style)