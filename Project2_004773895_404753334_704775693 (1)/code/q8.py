import os
import re
import cPickle
import numpy as np
import pandas as pd

from sklearn import linear_model
from collections import defaultdict
from heapq import nlargest

from sklearn.metrics import mean_squared_error
from math import sqrt

regex = re.compile('[^a-zA-Z0-9\t ]')
regex_rate = re.compile('[^a-zA-Z0-9\t. ]')
############################################################
print "Processing the movie and director"
movie_director_pair = defaultdict(list)
k = 0
with open("./project_2_data/director_movies.txt",'r') as f:
	director_movies = f.readlines()	
for line in director_movies:
	k = k + 1
	# print k
	content_dirty = line.strip()
	content_clean = regex.sub('', content_dirty).strip()
	content = content_clean.split('\t\t')
	director = content[0].strip()
	movies = content[1:]
	for movie in movies:
		movie = movie.strip()
		movie_director_pair[movie].append(director)
############################################################
print "Processing top 100 director"
with open("./project_2_data/top_100_movie.txt",'r') as f:
	top_200_movies = f.readlines()
director_movie_pair = defaultdict(list)
count = 0
for line in top_200_movies:
	if count < 100:
		content_dirty = line.strip()
		content_clean = regex.sub('', content_dirty).strip()
		content = content_clean.split('\t')
		movie = content[0].strip()
		if movie_director_pair[movie]:
			directors = movie_director_pair[movie]
			if len(directors) > 1:
				for director in directors:
					if count == 100:
						break
					count = count + 1
					director_movie_pair[director].append(count - 1)
			else :
				director = directors[0]
				count = count + 1
				director_movie_pair[director].append(count - 1)
		else:
			continue
	else:
		break
print len(director_movie_pair.keys())

############################################################
print "Processing rating of the movies"
with open("./project_2_data/movie_rating.txt",'r') as f:
	movie_ratings = f.readlines()

movie_rating_pair = dict()
for line in movie_ratings:
	content_dirty = line.strip()
	content_clean = regex_rate.sub('', content_dirty).strip()
	content = content_clean.split('\t\t')
	if len(content) < 2:
		continue
	else:
		rating = content[1].strip()
		movie = regex.sub('', content[0]).strip()
		movie_rating_pair[movie] = rating
print len(movie_rating_pair.keys())
############################################################
print "Processing movie actor/actress"
movie_actor_actress_pair = defaultdict(list)

if os.path.isfile("./Temp/actor_movie.pkl"):
	movie_actor_actress_pair = cPickle.load(open("./Temp/actor_movie.pkl"))	
else:
	with open("./project_2_data/actor_movies.txt",'r') as f:
		read_data = f.readlines()
	with open("./project_2_data/actress_movies.txt",'r') as f:
		read_data += f.readlines()	

	k = 0
	ac = []
	for line in read_data:
		k = k + 1
		# print k
		content_dirty = line.strip()
		content_clean = regex.sub('', content_dirty).strip()
		content = content_clean.split("\t\t")
		actor_actress = content[0].strip()
		movies = content[1:]
		if len(movies) < 10:
			continue
		for movie in movies:
			movie_actor_actress_pair[movie.strip()].append(actor_actress)
		
	with open("./Temp/actor_list.txt",'wb') as f:
		f.write("\n".join(ac))

	for key in movie_actor_actress_pair.keys():
		if (len(movie_actor_actress_pair[key]) < 10):
			del movie_actor_actress_pair[key]

	cPickle.dump(movie_actor_actress_pair,open("./Temp/actor_movie.pkl", "wb"))
print len(movie_actor_actress_pair)
########################################################
print "Processing Pagerank"
with open("./project_2_data/pagerank.txt",'r') as f:
	read_data = f.readlines()

actor_pagerank_pair = dict()
for line in read_data:
	content_dirty = line.strip()
	content_clean = regex_rate.sub('', content_dirty).strip()
	content = content_clean.split("\t")
	actor_actress = content[0].strip()
	pagerank = content[1].strip()
	actor_pagerank_pair[actor_actress] = pagerank

print len(actor_pagerank_pair.keys())
##########################################################
print "Creating the feature matrix training"
features = list()
labels = list()
rating = list()
if os.path.isfile("./Temp/features.pkl") and os.path.isfile("./Temp/labels.pkl"): 
	features = cPickle.load(open("./Temp/features.pkl"))
	rating = cPickle.load(open("./Temp/labels.pkl"))
else :
	count = 0
	for movie in movie_rating_pair.keys():
		if movie_actor_actress_pair[movie]:
			pagerank_list = []
			for actor in movie_actor_actress_pair[movie]:
				# print movie_actor_actress_pair[movie]
				pagerank_list.append(actor_pagerank_pair[actor])

			for i in xrange(0, 5 - len(pagerank_list)):
				pagerank_list.append(0)

			top_5 = nlargest(5,pagerank_list)
			# print top_5

			if movie_director_pair[movie]:
				director = movie_director_pair[movie][0]
			else:
				director = "unknown"

			director_boolean = [0]*101

			if director in director_movie_pair.keys():
				index = director_movie_pair[director][0]
				director_boolean[index] = 1
			else:
				director_boolean[100] = 1
			temp = top_5 + director_boolean
			features.append(temp)
			rating.append(movie_rating_pair[movie])

			count = count + 1
			print count

	df = pd.DataFrame(features)

	cPickle.dump(features, open("./Temp/features.pkl", "wb"))
	cPickle.dump(rating, open("./Temp/labels.pkl", "wb"))

reg = linear_model.Lasso(alpha = 0.1)
fit = reg.fit(features, rating)
# #########################################################################
print "Creating the feature matrix testing"

movie_list = "Batman v Superman: Dawn of Justice (2016)\t Mission: Impossible - Rogue Nation (2015)\t Minions (2015)"
features_test = list()
content_dirty = movie_list.strip()
content_clean = regex.sub('', content_dirty).strip()
movie_list = content_clean.split("\t")
# print movie_list

for movie in movie_list:
	movie = movie.strip()
	pagerank_list = []
	for actor in movie_actor_actress_pair[movie]:
		if actor in actor_pagerank_pair.keys():
			pagerank_list.append(actor_pagerank_pair[actor])

	for i in xrange(0, 5 - len(pagerank_list)):
		pagerank_list.append(0)

	top_5 = nlargest(5,pagerank_list)
	print top_5

	if movie_director_pair[movie]:
		director = movie_director_pair[movie][0]
	else:
		director = "unknown"

	director_boolean = [0]*101

	if director in director_movie_pair.keys():
		index = director_movie_pair[director][0]
		director_boolean[index] = 1
	else:
		director_boolean[100] = 1
	temp = top_5 + director_boolean
	features_test.append(temp)

df_test = pd.DataFrame(features_test)
predicted = fit.predict(df_test)
	

print 'Predicted rating: {}'.format(predicted)


y_actual = [7.1,7.5,6.4]
rms = sqrt(mean_squared_error(y_actual, predicted))
print 'RMSE: {}'.format(rms)
