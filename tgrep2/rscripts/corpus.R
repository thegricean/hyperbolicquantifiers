setwd('~/cogsci/projects/hyperbolicquantifiers/data/hyperbolicquantifiers/tgrep2/')
source('rscripts/helpers.R')
load("data/d.RData")

d = read.table("data/swbdext.tab", sep="\t", header=T, quote="")
summary(d)
nrow(d)

sample(d[,c("Partitive","Sentence")],10)
sample(paste(d$Partitive,"###",d$Sentence),10)

table(d$Partitive)

# get random sample of nullpartitive and partitive items
sample(paste(d[d$Partitive != "no",]$Partitive,"###",d[d$Partitive != "no",]$Sentence),10)
sample(d[d$Partitive != "no",]$Sentence,20)
