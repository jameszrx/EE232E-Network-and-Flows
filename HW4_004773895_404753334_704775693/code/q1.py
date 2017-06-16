import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from collections import defaultdict
from math import log

print "extract the stock value"
df = pd.read_csv('./finance_data/Name_sector.csv')
symbols_full = df.Symbol.T.tolist()
symbols = list()

closing_price = defaultdict(list)
for name in symbols_full:
	file = "./finance_data/data/"+name+".csv"
	# print file
	raw = pd.read_csv(file)
	# print len(raw.Close.T.tolist())
	if len(raw.Close.T.tolist()) >= 765:
		closing_price[name] = raw.Close.T.tolist()
		symbols.append(name)
print len(symbols)

print "Calculating individual rij"
tau = 1
c = 0
length = len(symbols)
p = np.zeros((length,length))
r_list = list()
for i in xrange(0,length):
	r = np.array([])
	cp = closing_price[symbols[i]]
	# print len(cpi)
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
			# print stock1,"\t",stock2,"\t",pij
# print p
pij = pd.DataFrame(data = p, index = symbols, columns = symbols)

pij_mat = pij.as_matrix()
pij_no_diag = list()
for i in xrange(0,len(symbols)):
	for j in xrange(0,len(symbols)):
		if i != j:
			pij_no_diag.append(pij_mat[i][j])

plt.hist(pij_no_diag,bins='auto')
plt.title("Histogram")
plt.savefig("./Graphs/pij_hist")

pij.to_csv('./Temp/p_i_j.csv')

