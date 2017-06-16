#read text files

genre_txt = open("C:/Users/James/Desktop/EE232/Project_2/pj2_data/movie_genre.txt", "r")

lines3 = genre_txt.read().split('\n')

##############################################
print "creating 1 tab version of data"

genre_list_file = open("movie_genre_1tab.txt", "w")
print len(lines3)

for i in xrange(0, len(lines3)):
	l = lines3[i].split('\t\t')
	if len(l) < 2:
		genre_list_file.write(str(l[0])+"\t"+"NA"+"\n")
	else:
		genre_list_file.write(str(l[0])+"\t"+str(l[1])+"\n")

genre_list_file.close()
print "All done."
