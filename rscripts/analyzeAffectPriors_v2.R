library(ggplot2)
library(reshape2)
library(plyr)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")


affect.priors <- read.csv("../data/affectPriors/long_v2.csv")
affect.priors$totalQuant <- factor(affect.priors$totalQuant)
affect.priors$eatenQuant <- factor(affect.priors$eatenQuant)
affect.priors$food <- factor(affect.priors$food, levels=c("M&M's", "cookies", "pies"))
affect.priors.long <- melt(data=affect.priors, id.vars=c("workerID", "gender", "age", "income", "language",
                                                     "order", "personA", "personB",  "food", "totalQuant", "eatenQuant"),
                         measure.vars=c("upset", "happy", "surprised", "neutral"))
colnames(affect.priors.long)[12] <- "affect"
colnames(affect.priors.long)[13] <- "probAffect"

affect.priors.s.means <- aggregate(data=affect.priors.long, probAffect ~ workerID, FUN=mean)
affect.priors.s.sds <- aggregate(data=affect.priors.long, probAffect ~ workerID, FUN=sd)
colnames(affect.priors.s.means)[2] <- "subjectMeans"
colnames(affect.priors.s.sds)[2] <- "subectSDs"
affect.priors.long <- join(affect.priors.long, affect.priors.s.means, by=c("workerID"))
affect.priors.long <- join(affect.priors.long, affect.priors.s.sds, by=c("workerID"))
affect.priors.long$zscore <- (affect.priors.long$probAffect - affect.priors.long$subjectMeans) / affect.priors.long$subectSDs
affect.priors.long$probit <- pnorm(affect.priors.long$zscore)

write.csv(affect.priors.long, "../data/affectPriors/affectPriors_v2_probit.csv")

qaffect.priors.summary <- summarySE(affect.priors.long, measurevar="probit", 
                                 groupvars=c("food", "totalQuant", "eatenQuant", "affect"))


ggplot(affect.priors.summary, aes(x=eatenQuant, y=probit)) +
  #geom_bar(stat="identity", color="black") +
  geom_point(size=2, color="black") +
  geom_line(aes(group=totalQuant), color="grey") +
  geom_errorbar(aes(ymin=probit-se, ymax=probit+se), width=0.05) +
  facet_grid(affect ~ food) +
  theme_bw()

write.csv(affect.priors.summary, "../data/affectPriors/affectPriors_v2.csv")

####################
# PCA
###################
comps <- princomp(data=affect.priors, ~ upset + happy + surprised + neutral, cor=TRUE)
summary(comps)
biplot(comps)
