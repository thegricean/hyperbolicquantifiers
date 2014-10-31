# Read from priors data and add to church code

import sys, re, string

priorsF = open("../data/priors/means_50.csv", "r")

priorsDict = dict()
firstline = 0
for l in priorsF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip().replace('"', "")
        toks = l.split(",")
        food = toks[1]
        totalQuant = toks[2]
        eatenQuant = toks[3]
        prob = toks[5]
        food_totalQuant = food + "_" + totalQuant
        if food_totalQuant in priorsDict:
            priorProbs = priorsDict[food_totalQuant]
        else:
            priorProbs = []
        priorProbs.append(prob)
        priorsDict[food_totalQuant] = priorProbs
    
#for k, v in priorsDict.iteritems():
#    print k + "," + ",".join(v)

affectF = open("../data/affectPriors/means_80_corrected.csv", "r")

affectDict = dict()
firstline = 0
for l in affectF:
    if firstline == 0:
        firstline = 1
    else:
        l = l.strip().replace('"', "")
        toks = l.split(",")
        food = toks[1]
        totalQuant = toks[2]
        eatenQuant = toks[3]
        prob = toks[5]
        food_totalQuant = food + "_" + totalQuant
        if food_totalQuant in affectDict:
            affectProbs = affectDict[food_totalQuant]
        else:
            affectProbs = []
        affectProbs.append(prob)
        affectDict[food_totalQuant] = affectProbs

for k in priorsDict.keys():
    f = open(k + "-notNone.church", "w")
    total = k.split("_")[1]
    f.write("(define total " + total + ")\n")
    f.write("(define (state-prior) (multinomial states '(" + " ".join(priorsDict[k]) + ")))\n")
    f.write("(define affect-prior (list ")
    for i in range(0, 11):
        f.write("'(" + str(i) + " " + affectDict[k][i] + ") ")
    f.write("))\n")
    model = open(sys.argv[1], "r")
    for l in model:
        f.write(l)



