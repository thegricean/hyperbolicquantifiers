library(ggplot2)
library(reshape2)
library(plyr)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

# Read data
food <- read.csv("../data/hyperbole/long_v3.csv")
food$food <- factor(food$food, levels=c("M&M's", "cookies", "pies"))
food$totalQuant <- factor(food$totalQuant)
food$eatenQuant <- factor(food$eatenQuant)

# Get sd of responses for each trial

food.sd <- aggregate(data=food, probability ~ workerID + food + quantifier, FUN=sd)
ggplot(food.sd, aes(x=probability)) +
  geom_histogram(binwidth=0.005) +
  facet_grid(.~quantifier) +
  theme_bw()

# Subject level

ggplot(food, aes(x=eatenQuant, y=probability, color=quantifier, shape=food)) +
  geom_point(size=2) +
  geom_line(aes(group=food)) +
  theme_bw() +
  facet_wrap(~workerID, ncol=4)

# Average across subjects
food.summary <- summarySE(food, measurevar="probability", 
                          groupvars=c("food", "quantifier", "eatenQuant"))

ggplot(food.summary, aes(x=eatenQuant, y=probability, color=quantifier)) +
  geom_point(size=2) +
  geom_line(aes(group=quantifier)) +
  geom_errorbar(aes(ymin=probability-se, ymax=probability+se), width=0.05) +
  theme_bw() +
  facet_grid(.~food) 

# Add price prior
priors.summary <- read.csv("../data//priors//priorMeans_v2.csv")
priors.summary$X <- NULL
priors.summary$quantifier <- "prior"
priors.summary$totalQuant <- NULL

food.summary <- rbind(food.summary, priors.summary)

ggplot(food.summary, aes(x=eatenQuant, y=probability, color=quantifier)) +
  geom_point(size=2) +
  geom_line(aes(group=quantifier)) +
  geom_errorbar(aes(ymin=probability-se, ymax=probability+se), width=0.05) +
  theme_bw() +
  facet_grid(.~food) +
  scale_color_manual(values=c("#ff6666", "#66cccc", "gray"))

