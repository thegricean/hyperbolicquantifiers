setwd('~/cogsci/projects/hyperbolicquantifiers/data/hyperbolicquantifiers/tgrep2/')
source('rscripts/helpers.R')
load("data/d.RData")

d = read.table("data/swbdext.tab", sep="\t", header=T, quote="")
# d.context = read.table("data/swbdext-context.tab", sep="\t", header=F)
# head(d.context)
# d.context$Item_ID = sapply(strsplit(as.character(d.context$V1),"%%%%"), "[", 1)
# d.context$ContextBefore = sapply(strsplit(as.character(d.context$V1),"%%%%"), "[", 2)
# d.context$ContextAfter = sapply(strsplit(as.character(d.context$V1),"%%%%"), "[", 3)
# head(d.context)
# d.context$V1 = N

summary(d)
nrow(d)

# all the "all of a sudden"s (27)
d[d$Partitive == "",]$Sentence

sample(paste(d$Partitive,"###",d$Sentence),10)
table(d$Partitive)

# get random sample of nullpartitive and partitive items
sample(paste(d[d$Partitive != "no",]$Partitive,"###",d[d$Partitive != "no",]$Sentence),10)

# get 5 random sample of each category
sample(d[d$Partitive == "no",]$Sentence,5) # 1545
sample(d[d$Partitive == "nullpartitive",]$Sentence,5) # 1053
sample(d[d$Partitive == "yes",]$Sentence,5) # 172

parts = droplevels(d[d$Partitive != "no",])
nrow(parts)

# generate a random sample of 150 cases for hand-annotation
write.table(parts[sample(nrow(parts), 150), c("Item_ID","Partitive","Sentence")],file="data/hand-annotation.csv",sep="\t",row.names=F,col.names=T,quote=F)

sampled = read.table("data/hand-annotation.csv",sep="\t",header=T,quote="")
head(sampled)
sampled$Sentence = gsub("\"","",sampled$Sentence)

sampledparts = droplevels(subset(parts, Sentence %in% sampled$Sentence))
sampledparts = droplevels(sampledparts[!duplicated(sampledparts$Sentence),])
nrow(sampledparts)
row.names(sampledparts) = sampledparts$Sentence
nrow(sampledparts)
sampled$NewID = sampledparts[sampled$Sentence,]$Item_ID
head(sampled)
sampled[as.character(sampled$Item_ID) != as.character(sampled$NewID),c("Item_ID","NewID")]
grep(":00$",sampled$Item_ID)
sampled$Item_ID = gsub(":00","", sampled$Item_ID)
sampled$NewID = NULL


write.table(sampled$Item_ID, file="data/hand-annotation-ids.txt", sep=" ",col.names=F,row.names=F,quote=F)
