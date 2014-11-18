import sys, re, string, random, numpy

epsilon = 0.000000001
foods = ["M&M's", "cookies", "pies"]
affectTypes = ["upset", "happy", "surprised"]
maxQuant = 11
numSamples = 1000
modelName = sys.argv[1]

# State priors file
pF = open("../data/priors/long_v2.csv")

priors = dict()
pFirstline = 0
for l in pF:
    l = l.strip()
    if pFirstline == 0:
        pFirstline = 1
    else:
        toks = l.split(",")
        workerID = int(toks[0])
        food = toks[6]
        eatenQuant = int(toks[10])
        prob = float(toks[11])
        if prob == 0.0:
            prob = epsilon
        if workerID not in priors:
            foodDict = dict()
            priors[workerID] = foodDict
        if food not in priors[workerID]:
            probArray = [0 for i in range(maxQuant)]
            priors[workerID][food] = probArray
        priors[workerID][food][eatenQuant] = prob

nPriors = max(priors.keys())

# Affect priors file
aF = open("../data/affectPriors/affectPriors_v2_probit.csv", "r")
affects = dict()
aFirstline = 0
for l in aF:
    if aFirstline == 0:
        aFirstline = 1
    else:
        l = l.replace('"', "")
        toks = l.split(",")
        workerID = int(toks[1])
        food = toks[9]
        eatenQuant = int(toks[11])
        affect = toks[12]
        prob = float(toks[17])
        if prob == float(0):
            prob = epsilon
        if workerID not in affects:
            foodDict = dict()
            affects[workerID] = foodDict
        if food not in affects[workerID]:
            affectDict = dict()
            affects[workerID][food] = affectDict
        if affect not in affects[workerID][food]:
            probArray = [0 for i in range(maxQuant)]
            affects[workerID][food][affect] = probArray        
        affects[workerID][food][affect][eatenQuant] = prob

for sample in range(1, numSamples+1):
    mF = open(modelName, "r")
    wF = open("models_basic/" + str(sample) + ".church", "w")
    wF.write("(define (item-prior item)\n")
    wF.write("(case item\n")    
    priorsIDs = [random.randint(1, nPriors) for i in range(nPriors)]
    for food in foods:
        probabilityDict = dict()
        for workerID in priorsIDs:
            for i in range(maxQuant):
                prob = priors[workerID][food][i]
                if i not in probabilityDict:
                    probabilityDict[i] = []
                probabilityDict[i].append(prob)
        probabilityMeans = [0 for i in range(maxQuant)]
        for i in range(maxQuant):
            probabilityMeans[i] = numpy.mean(probabilityDict[i])
        
        wF.write("\t(('" + food.replace("'", "")  + ") (multinomial states '(" + " ".join(map(str, probabilityMeans)) + ")))\n")
    wF.write("))\n")
    
    for affect in affectTypes:
        wF.write("(define (" + affect +"-prior item)\n")
        wF.write("(case item\n")
        for food in foods:
            probabilityDict = dict()
            for eatenQuant in range(maxQuant):
                for i in range(nPriors):
                    workerID = random.randint(1, nPriors)
                    while affects[workerID][food][affect][eatenQuant] == 0:
                        workerID = random.randint(1, nPriors)
                    prob = affects[workerID][food][affect][eatenQuant]
                    if eatenQuant not in probabilityDict:
                        probabilityDict[eatenQuant] = []
                    probabilityDict[eatenQuant].append(prob)
            probabilityMeans = [0 for i in range(maxQuant)]
            for i in range(maxQuant):
                probabilityMeans[i] = numpy.mean(probabilityDict[i])
                
            wF.write("\t(('" + food.replace("'", "")  + ") (list")
            for i in range(0, maxQuant):
                wF.write("'(" + str(i) + " " + str(probabilityMeans[i]) + ")")
            wF.write("))\n")
        wF.write("))\n")
    for l in mF:
        wF.write(l)
    

"""
for worker, dictionary in affects.iteritems():
    for k, v in dictionary.iteritems():
        for a, b in v.iteritems():
            print str(worker) + "\t" + k + "\t" + a + "\t" + ",".join(map(str, b)) 
"""
