import sys, re, string

f = open(sys.argv[1], "r")
print "quantifier,eatenQuant,affect,modelProb"
for l in f:
    l = l.strip()
    toks = l.split(")) (((")
    somes = toks[0].split(")) (")
    alls = toks[1].split(")) (")
    somelabels = somes[0].replace("((((", "").split(") (")
    somevalues = somes[1].replace("))", "").split()
    alllabels = alls[0].replace("((((", "").split(") (")
    allvalues = alls[1].replace(")))", "").split()
    for i in range(len(somelabels)):
        print "some" + "," + somelabels[i].replace(" ", ",") + "," + somevalues[i]
    for i in range(len(alllabels)):
        print "all" + "," + alllabels[i].replace(" ", ",") + "," + allvalues[i]
