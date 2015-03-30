import os 
import csv

f = open("swbdext-context.tab")
lines = [li.split("\t") for li in [l.rstrip() for l in f.readlines()]]
#lines = [li.split("%%%%") for li in [l.rstrip() for l in f.readlines()]]
f.close()

#print lines

d = {}

for l in lines[1:len(lines)]:
#	print l[0]
	d[l[0]] = l[1:3]
	
#print d	

idfile = open("hand-annotation-ids.txt")
ids = [l.rstrip() for l in idfile.readlines()]
idfile.close()

print len(ids)
print ids

towrite = []

for id in ids:
	try:
		towrite.append("\t".join([id]+d[id]))
	except KeyError:
		print id
		continue
	
contextfile = open("annotation-context.txt","w")	
contextfile.write("\n".join(towrite))
contextfile.close()



#outfile = open("swbdext-context.tab","w")
##outfile.write("\n".join(["%%%%".join(l) for l in lines]))
#outfile.write("\n".join(["\t".join(l) for l in lines]))
#outfile.close