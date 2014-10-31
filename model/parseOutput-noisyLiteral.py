import sys, re, string

foods = ["blueberries", "M&M's", "strawberries", "cookies", "bananas", "pies"]
totalQuants = [10, 100]

print "quantifier,food,totalQuant,eatenQuant,probability"
for food in foods:
    for totalQuant in totalQuants:
        filename = "output/" + food + "_" + str(totalQuant) + "-noisyLiteral.txt"
        f = open(filename, "r")
        for l in f:
            l = l.strip()
            toks = l.split(")) ((")
            someOut = toks[0].split(") (")
            allOut = toks[1].split(") (")
            someLabels = [x.replace("(((", "").replace(" ",",") for x in someOut[0].split(" ")]
            someValues = someOut[1].replace("))", "").split(" ")
            allLabels = [x.replace("(((", "").replace(" ",",") for x in allOut[0].split(" ")]
            allValues = allOut[1].replace(")))", "").split(" ")
            for i in range(len(someLabels)):
                print "some" + "," + food + "," + str(totalQuant) + "," + someLabels[i] + "," + someValues[i]
            for i in range(len(allLabels)):
                print "all" + "," + food + "," + str(totalQuant) + "," + allLabels[i] + "," + allValues[i]
