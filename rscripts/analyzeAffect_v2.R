library(ggplot2)
library(reshape2)
library(plyr)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

affect <- read.csv("../data/hyperbole-affect/long_v3.csv")
# drop rows that contain null value
affect <- subset(affect, surprised!="null")

affect$eatenQuant <- factor(affect$eatenQuant)
affect.long <- melt(data=affect, id.vars=c("workerID", "gender", "age", "income", "language", "order", "personA", "personB",
                                 "food", "totalQuant", "eatenQuant", "quantifier"),
               measure.vars=c("upset", "happy", "surprised", "neutral"))

colnames(affect.long)[13] <- "affect"
colnames(affect.long)[14] <- "probAffect"

####################
# PCA
###################
comps.posterior <- princomp(data=affect, ~ upset + happy + surprised + neutral, cor=TRUE)
summary(comps.posterior)
biplot(comps.posterior)



#########################
# Z score ratings
#########################
affect.s.means <- aggregate(data=affect.long, probAffect ~ workerID, FUN=mean)
colnames(affect.s.means)[2] <- "subjectMean"
affect.s.sds <- aggregate(data=affect.long, probAffect ~ workerID, FUN=sd)
colnames(affect.s.sds)[2] <- "subjectSDs"
affect.long <- join(affect.long, affect.s.means, by="workerID")
affect.long <- join(affect.long, affect.s.sds, by="workerID")
affect.long$zscored <- (affect.long$probAffect - affect.long$subjectMean) / affect.long$subjectSDs
affect.long$probit <- pnorm(affect.long$zscored)

affect.summary <- summarySE(affect.long, measurevar="probit", groupvars=c("food", "eatenQuant", "quantifier", "affect"))
ggplot(affect.summary, aes(x=eatenQuant, y=probit, color=quantifier))+
  geom_point() +
  geom_line(aes(group=quantifier)) +
  geom_errorbar(aes(ymin=probit-se, ymax=probit+se), width=0.05) +
  facet_grid(food~affect) +
  theme_bw()

# rbind with affect priors to plot everything
affect.summary <- summarySE(affect.long, measurevar="probAffect", groupvars=c("food", "eatenQuant", "quantifier", "affect"))
affect.priors <- read.csv("../data/affectPriors/affectPriors_v2.csv")
affect.priors$X <- NULL
affect.priors$totalQuant <- NULL
affect.priors$quantifier <- "prior"

affect.summary <- rbind(affect.summary, affect.priors)

affect.summary <- join(affect.summary, affect.priors, by=c("food", "eatenQuant", "affect"))
affect.summary$quantifier <- factor(affect.summary$quantifier, levels=c("all", "some", "none", "prior"))

ggplot(affect.summary, aes(x=eatenQuant, y=probAffect, color=quantifier)) +
  geom_point(size=2) +
  geom_line(aes(group=quantifier)) +
  geom_errorbar(aes(ymin=probAffect-se, ymax=probAffect+se), width=0.05) +
  facet_grid(food~affect) +
  theme_bw() +
  scale_color_manual(values=c("#ff6666", "#66cccc", "black", "gray"))

# Join with affect priors for differences
affect.summary <- summarySE(affect.long, measurevar="probAffect", groupvars=c("food", "eatenQuant", "quantifier", "affect"))
affect.priors <- read.csv("../data/affectPriors/affectPriors_v2.csv")
affect.priors$X <- NULL
affect.priors$totalQuant <- NULL
colnames(affect.priors)[5] <- "affectPrior"

affect.summary <- join(affect.summary, affect.priors, by=c("food", "eatenQuant", "affect"))
affect.summary$difference <- affect.summary$probAffect - affect.summary$affectPrior

ggplot(affect.summary, aes(x=eatenQuant, y=difference, color=quantifier)) +
  geom_point(size=2) +
  geom_line(aes(group=quantifier)) +
  facet_grid(food~affect) +
  theme_bw() 

