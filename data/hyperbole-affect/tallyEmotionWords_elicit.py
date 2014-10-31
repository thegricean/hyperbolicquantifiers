import sys, re, string

emoF = open("EMOT.txt", "r")
emoWords = []

def stripPunctuation(sentence):
    sentence = sentence.translate(None, ",!.;?")
    return sentence

for l in emoF:
    l = l.strip()
    emoWords.append(l)

f = open(sys.argv[1], "r")

firstline = 0
for l in f:
    l = l.strip()
    if firstline == 0:
        print l
        firstline = 1
    else:
        fields = l.split(",")
        response = fields[len(fields)-1].lower()
        response = stripPunctuation(response)
        words = response.split()
        wordsToKeep = []
        for word in words:
            if word in emoWords:
                wordsToKeep.append(word)
        if len(wordsToKeep) == 0:
            wordsToKeep.append("none")
        print ",".join(fields[0:len(fields)-1]) + "," + ";".join(wordsToKeep)
