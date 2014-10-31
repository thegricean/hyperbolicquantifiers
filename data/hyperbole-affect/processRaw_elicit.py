# trims down raw data file to include only relevant information
# removes and replaces excess symbols, punctuations, etc

import sys, re, string

f = open(sys.argv[1], "r")

# define the fields to keep
relevant_fields = ["Answer.gender", "Answer.age", "Answer.income", "Answer.nativeLanguage", "Answer.conditions", "Answer.orders", "Answer.personAs", "Answer.personBs","Answer.foods", "Answer.totalQuants", "Answer.eatenQuants", "Answer.preciseEatenQuants", "Answer.quantifiers"]
relevant_indices = []

#field that needs to be specially processed
special_fields = ["Answer.affects"]
special_indices = []

firstline = 0
workerID = 1
for l in f:
    l = l.strip()
    l = l.replace("[", "")
    l = l.replace("]", "")
    if firstline == 0:
        l = l.replace('"', "")
        toks = l.split("\t")
        for field in relevant_fields:
            relevant_indices.append(toks.index(field))
        for field in special_fields:
            special_indices.append(toks.index(field))
        firstline = 1
        print "workerID" + "\t" + "\t".join(relevant_fields) + "\t" + "\t".join(special_fields)
    else:
        toks = l.split("\t")
        fieldsToPrint = []
        for i in relevant_indices:
            fieldToPrint = toks[i].replace('"', "")
            fieldsToPrint.append(fieldToPrint)
        for i in special_indices:
            fieldToPrint = toks[i].replace('"",""', '"";""').replace(',', " ").replace('"";""', '"",""').replace('"', "")
            fieldsToPrint.append(fieldToPrint)
        print str(workerID) + "\t" + "\t".join(fieldsToPrint)
        workerID = workerID + 1



