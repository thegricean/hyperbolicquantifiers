# Normalize ratings for each trial to sum up to 1 (turn ratings into probabilities)

import sys, re, string

f = open(sys.argv[1], "r")

def normalize(vector):
    vector = [float(x) for x in vector]
    normalizer = sum(vector)
    return [x/normalizer for x in vector]

subject_indices = range(0,5)
item_indices = range(5,10)
response_indices = range(10,21)

# Order of the fields
print "workerID,gender,age,income,language,order,food,totalQuant,personA,personB,eatenQuant,probability"

firstline = 0
for l in f:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip().replace('"', "")
        toks = l.split("\t")
        numTrials = len(toks[item_indices[0]].split(","))
        
        # Make vector of all responses in a single trial
        for trial in range(numTrials):
            for priorNum in range(len(response_indices)):
                responses = [toks[i].split(",")[trial] for i in response_indices]
                # Normalize ratings to sum up to one
                responses = normalize(responses)
                print ",".join([toks[i] for i in subject_indices]) + "," + ",".join([toks[i].split(",")[trial] for i in item_indices]) + "," + str(priorNum) + "," + str(responses[priorNum])
