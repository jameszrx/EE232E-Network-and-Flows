import re

with open("./project_2_data/movie_rating.txt",'r') as f:
	read_data = f.readlines()
with open("./project_2_data/movie_rating_clean.txt",'wb') as fw:
	for line in read_data:
		content_dirty = line.strip()
		regex = re.compile('[^a-zA-Z0-9\t. ]')
		content_clean = regex.sub('', content_dirty)
		fw.write(str(content_clean)+"\n")