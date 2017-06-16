import pandas as pd
import numpy as np
import itertools
import matplotlib.pyplot as plt
from igraph import *
import csv
from random import shuffle

DATA_PATH = "finance_data/data/"

def log_return(df):
    return np.log(df.Close) - np.log(df.Close.shift(1))


def correlation(df1, df2):
    r1, r2 = log_return(df1),log_return(df2)
    return (np.mean(r1*r2)-np.mean(r1)*np.mean(r2))/np.sqrt((np.mean(r1**2)-np.mean(r1)**2)*(np.mean(r2**2)-np.mean(r2)**2))


stocks = {}
files = [x for x in os.listdir(DATA_PATH) if x.endswith('.csv')]
for file in files:
    df = pd.read_csv(DATA_PATH + file)
    if len(df) == 765:
        stocks[file[:-4]] = df

print(len(stocks))

edge_list = []
count = 0
for edge in itertools.combinations(list(stocks),2):
    if count %1000 == 0:
        print(count)
    count+=1
    s1,s2 = edge[0],edge[1]
    cor = correlation(stocks[s1],stocks[s2])
    w = np.sqrt(2*(1-cor))
    edge_list.append((s1,s2, w))

wlist = [e[2] for e in edge_list]

plt.hist(wlist)
plt.title("Histogram of link length")
plt.xlabel("Value")
plt.ylabel("Frequency")
plt.show()

g = Graph.TupleList(edge_list,weights=True)

print("vertices length", g.vcount())
print("edge length", g.ecount())


sectors = {}

with open("finance_data/Name_sector.csv") as f:
    for line in csv.DictReader(f,):
        if line['Symbol'] in stocks:
            sectors[line['Symbol']] = line['Sector']

mst = g.spanning_tree(weights=g.es['weight'])

# q4
plist = []

for v in mst.vs:
    neighbor = mst.neighbors(v)
    count = 0
    for n in neighbor:
        if sectors[v['name']] == sectors[mst.vs[n]['name']]:
            count+=1
    plist.append(float(count)/len(neighbor))

print("performance:",np.mean(plist))


random_values = list(sectors.values())
random_sectors = {}
shuffle(random_values)
i = 0
for key in sectors.keys():
    random_sectors[key] = random_values[i]
    i+=1


random_plist = []
for v in mst.vs:
    neighbor = g.neighbors(v)
    count = 0
    for n in neighbor:
        if random_sectors[v['name']] == random_sectors[mst.vs[n]['name']]:
            count+=1
    random_plist.append(float(count)/len(neighbor))

print("random performance:",np.mean(random_plist))

# q5

cycle_weight = []
for i in range(0,len(g.vs)-1):
    cycle_weight.append(g.es[g.get_eid(i,i+1)]['weight'])

cycle_weight.append(g.es[g.get_eid(0,len(g.vs)-1)]['weight'])
print("cycle length:",sum(cycle_weight))

mst_weight = []
for e in mst.es:
    mst_weight.append(e['weight'])

print("2 times MST length:",2*sum(mst_weight))

