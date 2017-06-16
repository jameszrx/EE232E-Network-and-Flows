import time
import re

#Read txt files
actor_movie_txt = open("C:/Users/James/Desktop/EE232/Project_2/pj2_data/actor_movies.txt", "r")
actress_movie_txt = open("C:/Users/James/Desktop/EE232/Project_2/pj2_data/actress_movies.txt", "r")

lines1 = actor_movie_txt.read().split('\n')
lines2 = actress_movie_txt.read().split('\n')

##############################################
print "creating movie-actor dictionary"
movie_to_actor = dict()

execlude_start = "$&/@?*"
for i in xrange(0, len(lines1)):
	l = lines1[i].split('\t\t')
	if not l[0]:
		continue
	if l[0][0] in execlude_start:
		continue
	if l[0][0].isdigit() and l[0] != "50 Cent":
		continue
	for movie in l[1:]:
		pos = movie.find(')')
		movie = movie[:pos+1]
		movie.strip()
		if not movie:
			continue
		actor_ref = l[0]
		actor_ref = actor_ref.strip()
		if movie in movie_to_actor:
			movie_to_actor[movie].append(actor_ref)
		else:
			movie_to_actor[movie] = [actor_ref]

for i in xrange(0, len(lines2)):
	l = lines2[i].split('\t\t')
	for movie in l[1:]:
		pos = movie.find(')')
		movie = movie[:pos+1]
		movie.strip()
		if not movie:
			continue
		actress_ref = l[0]
		actress_ref = actress_ref.strip()
		if movie in movie_to_actor:
			movie_to_actor[movie].append(actress_ref)
		else:
			movie_to_actor[movie] = [actress_ref]

print(len(movie_to_actor))

#################################################
print "removing movie with less than 15 actors"

for j in movie_to_actor.keys():
	if(len(movie_to_actor[j]) < 15):
		del movie_to_actor[j]
print(len(movie_to_actor))

#################################################
print "creating actor-movie dictionary"
actor_to_movie = dict()

for movie in movie_to_actor:
	for actor in movie_to_actor[movie]:
		if actor in actor_to_movie:
			actor_to_movie[actor].append(movie)
		else:
			actor_to_movie[actor] = [movie]


print(len(actor_to_movie))

##################################################
print "Creating movie-pair-edge dictionary & writing to files.... "

movie_pair_edge = dict()
count = 0
for kvpair in movie_to_actor.items():
	curr_mov = kvpair[0]
	curr_actor_list = kvpair[1]
	co_movie_list = dict()
	for actor_ele in curr_actor_list:
		movies_attend = actor_to_movie[actor_ele]
		for movie_ele in movies_attend:
			if movie_ele == curr_mov:
				continue
			testlist = [str(curr_mov), str(movie_ele)]
			testlist.sort()
			teststr = str(testlist[0])+"\t"+str(testlist[1])
			if(teststr in movie_pair_edge):
				continue
			if movie_ele in co_movie_list:
				co_movie_list[movie_ele] = co_movie_list[movie_ele] + 1
			else:
				co_movie_list[movie_ele] = 1
	count = count + len(co_movie_list)

	for overlap_movie in co_movie_list.keys():
		jaccard_num = co_movie_list[overlap_movie]
		union_num = len(curr_actor_list) + len(movie_to_actor[overlap_movie]) - jaccard_num
		if union_num == 0:
			continue
		jaccard_index = float(jaccard_num)/union_num
		potential_key_list = [str(curr_mov), str(overlap_movie)]
		potential_key_list.sort()
		edge_key_str = str(potential_key_list[0]) + "\t" + str(potential_key_list[1])
		movie_pair_edge[edge_key_str] = jaccard_index
	print(count)

edge_list_file = open("edge_list_file_15actor_singletab.txt", "w")
for edge_key in movie_pair_edge.keys():
	edge_list_file.write(str(edge_key)+"\t"+str(movie_pair_edge[edge_key])+"\n")

edge_list_file.close()

print "All done."
#end
