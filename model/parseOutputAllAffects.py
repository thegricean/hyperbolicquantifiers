import sys, re, string

foods = ["M&M's", "M&M's", "cookies", "cookies", "pies", "pies"]
quantifiers = ["some", "all", "some", "all", "some", "all"]

f = open(sys.argv[1], "r")
print "food,quantifier,eatenQuant,upset,happy,surprised,probability"

for l in f:
    l = l.strip()
    toks = l.split(")) (((")
    for n in range(len(toks)):
        output = toks[n].split(")) (")
        labels = [x.replace("((((", "").replace(" ", ",") for x in output[0].split(") (")]
        values = output[1].replace("))", "").split(" ")
        for i in range(len(labels)):
            print foods[n] + "," + quantifiers[n] + "," + labels[i] + "," + values[i].replace(")", "")

