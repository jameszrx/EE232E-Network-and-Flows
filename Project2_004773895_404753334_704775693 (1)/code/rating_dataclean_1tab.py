#read text files

rating_txt = open("C:/Users/James/Desktop/EE232/Project_2/pj2_data/movie_rating.txt", "r")

lines3 = genre_txt.read().split('\n')

##############################################
print "creating 1 tab version of data"

rating_list_file = open("movie_rating_1tab.txt", "w")
print len(lines)

for i in xrange(0, len(lines)):
	l = lines[i].split('\t\t')
	if len(l) < 2:
		rating_list_file.write(str(l[0])+"\t"+"NA"+"\n")
	else:
		rating_list_file.write(str(l[0])+"\t"+str(l[1])+"\n")

rating_list_file.close()
print "All done."
