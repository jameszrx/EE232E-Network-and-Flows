import re

with open("./project_2_data/actor_movies.txt",'r') as f:
	read_data = f.readlines()
with open("./project_2_data/actress_movies.txt",'r') as f:
	read_data += f.readlines()	

data = list()
ac = set()
mv = set()

for line in read_data:
	dict = {}
	content_dirty = line.strip()
	regex = re.compile('[^a-zA-Z0-9\t ]')
	content_dirty = regex.sub('', content_dirty)
	content = content_dirty.strip().split("\t\t")
	if len(content) >= 11:
		dict['actor'] = content[0]
		ac.add(content[0].strip())
		dict['movie'] = set(content[1:])
		for m in set(content[1:]):
			m = m.strip()
			mv.add(m)
		data.append(dict)
print len(mv)
print len(ac)
with open("./edge_list_5.txt",'wb') as f:
	for i in xrange(0,len(data)):
		print i
		for j in xrange(i+1, len(data)):
			w_ij = float(len(data[i]['movie'] & data[j]['movie']))/float(len(data[i]['movie']))
			w_ji = float(len(data[i]['movie'] & data[j]['movie']))/float(len(data[j]['movie']))
			if w_ij > 0.0:
				continue
				f.write(str(data[i]['actor'])+"\t"+str(data[j]['actor'])+"\t"+str(w_ij)+"\n")
				f.write(str(data[j]['actor'])+"\t"+str(data[i]['actor'])+"\t"+str(w_ji)+"\n")