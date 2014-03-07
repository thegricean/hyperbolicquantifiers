# created by jdegen 03/04/2014

# modify path
setwd("~/cogsci/projects/hyperbolicquantifiers/data/hyperbolicquantifiers/")
d = read.table("data/swbd.tab",sep="\t",header=TRUE)
head(d)
summary(d)

head(d[d$Word == "all",]$Sentence,5)
head(d[d$Word == "always",]$Sentence,5)
head(d[d$Word == "everything",]$Sentence,5)
head(d[d$Word == "all" & d$Partitive == "yes",]$Sentence,10)

head(d[d$Word == "none",]$Sentence,5)
head(d[d$Word == "never",]$Sentence,5)
head(d[d$Word == "nothing",]$Sentence,5)

table(d$Word)
table(d$Word,d$Partitive)
sort(table(d$Phrase))
