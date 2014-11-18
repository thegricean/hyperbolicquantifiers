import sys, re, string

# Priors file
pF = open("../data/priors/priorMeans_v2.csv", "r")
# Affect priors file
aF = open("../data/affectPriors/affectPriors_v2.csv", "r")
# Model file
mF = open(sys.argv[1], "r")

priors = dict()
upsetPriors = dict()
happyPriors = dict()
surprisedPriors = dict()

pFirstline = 0
aFirstline = 0

for l in pF:
    l = l.strip().replace('"', "").replace("'", "")
    if pFirstline == 0:
        pFirstline = 1
    else:
        toks = l.split(",")
        food = toks[1]
        eatenQuant = toks[3]
        prob = toks[5]
        if food not in priors:
            probArray = [prob]
            priors[food] = probArray
        else:
            priors[food].append(prob)

for l in aF:
    l = l.strip().replace('"', "").replace("'", "")
    if aFirstline == 0:
        aFirstline = 1
    else:
        toks = l.split(",")
        food = toks[1]
        eatenQuant = toks[3]
        affect = toks[4]
        prob = toks[6]
        if affect == "upset":
            if food not in upsetPriors:
                probArray = [prob]
                upsetPriors[food] = probArray
            else:
                upsetPriors[food].append(prob)
        elif affect == "happy":
            if food not in happyPriors:
                probArray = [prob]
                happyPriors[food] = probArray
            else:
                happyPriors[food].append(prob)
        elif affect == "surprised":
            if food not in surprisedPriors:
                probArray = [prob]
                surprisedPriors[food] = probArray
            else:
                surprisedPriors[food].append(prob)


#print surprisedPriors["'M&Ms'"]

#for k, v in happyPriors.iteritems():
#    print k + " " + ",".join(v)

items = ["M&Ms", "cookies", "pies"]
# Print priors
print "(define (item-prior item)"
print "(case item"
for item in items:
    print "\t(('" + item + ") (multinomial states '(" + " ".join(priors[item]) + ")))"
print "))"

# Print affect priors
print "(define (upset-prior item)"
print "(case item"
for item in items:
    print "\t(('" + item + ") (list",
    for i in range(0, 11):
        print "'(" + str(i) + " " + upsetPriors[item][i] + ")",
    print "))"
print "))"

print "(define (happy-prior item)"
print "(case item"
for item in items:
    print "\t(('" + item + ") (list",
    for i in range(0, 11):
        print "'(" + str(i) + " " + happyPriors[item][i] + ")",
    print "))"
print "))"

print "(define (surprised-prior item)"
print "(case item"
for item in items:
    print "\t(('" + item + ") (list",
    for i in range(0, 11):
        print "'(" + str(i) + " " + surprisedPriors[item][i] + ")",
    print "))"
print "))"

for l in mF:
    l = l.strip()
    print l

#for k, v in priors.iteritems():
#    print k + "\t" + ",".join(v)


