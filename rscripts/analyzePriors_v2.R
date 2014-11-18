library(ggplot2)
library(reshape2)
library(plyr)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

# Read priors data
priors <- read.csv("../data/priors/long_v2.csv")
priors$food <- factor(priors$food, levels=c("M&M's", "cookies", "pies"))
priors$totalQuant <- factor(priors$totalQuant)
#priors$eatenQuantLabels <- priors$eatenQuant * 10
priors$eatenQuant <- factor(priors$eatenQuant)
#priors$eatenQuantLabels <- factor(priors$eatenQuantLabels)

# Average across subjects
priors.summary <- summarySE(priors, measurevar="probability", 
                                 groupvars=c("food", "totalQuant", "eatenQuant"))

write.csv(priors.summary, "../data/priors/priorMeans_v2.csv")

# Visualize items/quantities
ggplot(priors.summary, aes(x=eatenQuant, y=probability)) +
  facet_grid(.~food) +
  geom_point(size=2, color="black") +
  geom_line(aes(group=totalQuant), color="grey") +
  #geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymax=probability+se, ymin=probability-se), width=0.05) +
  theme_bw() +
  xlab("Number eaten") +
  scale_fill_discrete(guide=FALSE) +
  ggtitle("Priors")