library(ggplot2)
library(reshape2)
library(plyr)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")

d <- read.csv("../data/hyperbole-affect/affect-3_long.csv")
d$eatenQuant <- factor(d$eatenQuant, labels=c("30%", "80%", "100%"))
d$normalizer <- d$upset + d$annoyed + d$angry + d$disgusted + d$excited + d$happy + d$surprised

#############################
# Find correlations among emotion ratings
#############################

d.cor.matrix <- as.matrix(cor(d[,15:22]))

# Compute probability of not any of the non-neutral affects
d$non.emotion <- (1-d$upset) * (1-d$annoyed) * (1-d$angry) * (1-d$disgusted) * (1-d$excited) * (1-d$happy) * (1-d$surprised) 

cor.test(d$non.emotion, d$neutral)


##########################
# Turn to long form
##########################

d.long <- melt(data=d, id.vars=c("workerID", "gender", "age", "income", "language", "condition", "order", "personA", "personB",
                                 "food", "totalQuant", "eatenQuant", "preciseEatenQuant", "quantifier", "normalizer"),
                    measure.vars=c("upset", "annoyed", "angry", "disgusted", "excited", "happy", "surprised", "neutral"))

colnames(d.long)[16] <- "emotion"
colnames(d.long)[17] <- "rating"

# Normalize rating
d.long$rating.normalized <- d.long$rating / d.long$normalizer

###########################
# Find max and min ratings for each subject
###########################
d.max <- aggregate(data=d.long, rating ~ workerID, FUN=max)
colnames(d.max)[2] <- "maxRating"
d.min <- aggregate(data=d.long, rating ~ workerID, FUN=min)
colnames(d.min)[2] <- "minRating"
d.min.max <- join(d.max, d.min, by="workerID")
d.long.max.min <- join(d.long, d.min.max, by="workerID")
d.long.max.min$stretched <- ifelse(d.long.max.min$rating==d.long.max.min$maxRating, 1,
                                   ifelse(d.long.max.min$rating==d.long.max.min$minRating, 0,
                                   (d.long.max.min$rating - d.long.max.min$minRating) / 
                                     (d.long.max.min$maxRating - d.long.max.min$minRating)))

##########################
# Visualize by subject
##########################
ggplot(d.long, aes(x=eatenQuant, y=rating, color=quantifier)) +
  geom_point(size=3) +
  theme_bw() +
  facet_grid(emotion ~ workerID)

ggplot(d.long, aes(x=eatenQuant, y=rating.normalized, color=quantifier)) +
  geom_point(size=3) +
  theme_bw() +
  facet_grid(emotion ~ workerID)

ggplot(d.long.max.min, aes(x=eatenQuant, y=stretched, color=quantifier)) +
  geom_point(size=3) +
  theme_bw() +
  facet_grid(emotion ~ workerID)

##########################
# Visualize effect of quantifier
##########################

# Raw

d.summary <- summarySE(d.long, measurevar=c("rating"), 
                       groupvars=c("quantifier", "eatenQuant", "emotion"))

ggplot(d.summary, aes(x=eatenQuant, y=rating, color=quantifier)) +
  geom_point(size=3) +
  geom_line(aes(group=quantifier)) +
  geom_errorbar(aes(ymin=rating-ci, ymax=rating+ci), width=0.1) +
  theme_bw() +
  facet_wrap(~emotion, ncol=4)
  #facet_grid(food ~ emotion)

# Normalized to sum to 1

d.summary.normalized <- summarySE(d.long, measurevar=c("rating.normalized"), 
                       groupvars=c("quantifier", "eatenQuant", "emotion"))

ggplot(d.summary.normalized, aes(x=eatenQuant, y=rating.normalized, color=quantifier)) +
  geom_point(size=3) +
  geom_line(aes(group=quantifier)) +
  geom_errorbar(aes(ymin=rating.normalized-ci, ymax=rating.normalized+ci), width=0.1) +
  theme_bw() +
  facet_wrap(~emotion, ncol=4)

# Stretched to fix min and max

d.summary.stretched <- summarySE(d.long.max.min, measurevar=c("stretched"),
                                 groupvars=c("quantifier", "eatenQuant", "emotion"))

ggplot(d.summary.stretched, aes(x=eatenQuant, y=stretched, color=quantifier)) +
  geom_point(size=3) +
  geom_line(aes(group=quantifier)) +
  geom_errorbar(aes(ymin=stretched-ci, ymax=stretched+ci), width=0.1) +
  theme_bw() +
  facet_wrap(~emotion, ncol=4)

##########################################################
# AFFFECT PRIORS
##########################################################
d.priors <- read.csv("../data//affectPriors//affectPriors-affect_long.csv")
d.priors$eatenQuant <- factor(d.priors$eatenQuant, labels=c("30%", "80%", "100%"))
d.priors.long <- melt(data=d.priors, id.vars=c("workerID", "gender", "age", "income", "language", "order", "personA", "personB",
                                 "food", "totalQuant", "eatenQuant", "preciseEatenQuant", "literalQuantifier"),
               measure.vars=c("upset", "annoyed", "angry", "disgusted", "excited", "happy", "surprised", "neutral"))

colnames(d.priors.long)[14] <- "emotion"
colnames(d.priors.long)[15] <- "prior"

d.priors.summary <- summarySE(d.priors.long, measurevar="prior", groupvars=c("eatenQuant", "emotion"))
colnames(d.priors.summary)[4] <- "rating"
d.priors.summary$quantifier <- "prior"

# Combine priors and posterior ratings
d.priors.ratings.summary <- rbind(d.summary, d.priors.summary)

ggplot(d.priors.ratings.summary, aes(x=eatenQuant, y=rating, color=quantifier)) +
  geom_point(size=3) +
  geom_line(aes(group=quantifier)) +
  geom_errorbar(aes(ymin=rating-ci, ymax=rating+ci), width=0.1) +
  theme_bw() +
  facet_wrap(~emotion, ncol=4) +
  scale_color_manual(values=c("#ff6666", "#66cccc", "gray"))

# By food
d.summary.food <- summarySE(d.long, measurevar=c("rating"),
                            groupvars=c("quantifier", "eatenQuant", "emotion", "food"))

d.priors.summary.food <- summarySE(d.priors.long, measurevar=c("prior"),
                                   groupvars=c("eatenQuant", "emotion", "food"))

colnames(d.priors.summary.food)[5] <- "rating"
d.priors.summary.food$quantifier <- "prior"
d.priors.ratings.summary.food <- rbind(d.summary.food, d.priors.summary.food)

ggplot(d.priors.ratings.summary.food, aes(x=eatenQuant, y=rating, color=quantifier)) +
  geom_point(size=2) +
  geom_line(aes(group=quantifier)) +
  geom_errorbar(aes(ymin=rating-ci, ymax=rating+ci), width=0.1) +
  theme_bw() +
  facet_grid(food~emotion) +
  scale_color_manual(values=c("#ff6666", "#66cccc", "gray"))

# By total quantity

d.summary.totalQuant <- summarySE(d.long, measurevar=c("rating"),
                            groupvars=c("quantifier", "eatenQuant", "emotion", "totalQuant"))

d.priors.summary.totalQuant <- summarySE(d.priors.long, measurevar=c("prior"),
                                   groupvars=c("eatenQuant", "emotion", "totalQuant"))

colnames(d.priors.summary.totalQuant)[5] <- "rating"
d.priors.summary.totalQuant$quantifier <- "prior"
d.priors.ratings.summary.totalQuant <- rbind(d.summary.totalQuant, d.priors.summary.totalQuant)

ggplot(d.priors.ratings.summary.totalQuant, aes(x=eatenQuant, y=rating, color=quantifier)) +
  geom_point(size=3) +
  geom_line(aes(group=quantifier)) +
  geom_errorbar(aes(ymin=rating-ci, ymax=rating+ci), width=0.1) +
  theme_bw() +
  facet_grid(totalQuant~emotion)

##################################
# Read in model case study for 10 cookies and upset-ness
##################################

m <- read.csv("../model/test-cookies.csv")
m$eatenQuant <- factor(m$eatenQuant, labels=c("0%", "10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%"))
m.normalizer <- aggregate(data=m, modelProb ~ quantifier + eatenQuant, FUN=sum)
colnames(m.normalizer)[3] <- "stateProb"
m <- join(m, m.normalizer, by=c("quantifier", "eatenQuant"))
m$probAffect <- m$modelProb / m$stateProb
m.affect <- subset(m, affect==1)

# Extrapolated affect prior for "upset", demonstration purposes
m.prior <- data.frame(eatenQuant=c("0%", "10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%"),
                      probAffect= c(0.12333333333333, 0.1390625, 0.244230769230769, 0.4875, 
                                     0.507142857142857, 0.550625, 0.592857142857143, 0.630769230769231, 
                                     0.6833, 0.70, 0.7406))

m.prior$quantifier <- "prior"
m.prior$affect <- "na"
m.prior$stateProb <- "na"
m.prior$modelProb <- "na"
m.affect <- rbind(m.affect, m.prior)

ggplot(m.affect, aes(x=eatenQuant, y=probAffect, color=quantifier)) +
  geom_point(size=3) + 
  geom_line(aes(group=quantifier)) +
  theme_bw() +
  scale_color_manual(values=c("#ff6666", "#66cccc", "gray"))

# calculate difference from prior
m.affect.difference <- join(m.prior, subset(m.affect, quantifier != "prior"), by=c("eatenQuant"))
colnames(m.affect.difference)[2] <- "priorProb"
colnames(m.affect.difference)[3] <- "prior"
m.affect.difference$difference <- m.affect.difference$probAffect - m.affect.difference$priorProb

m.affect.difference$eatenQuant <- factor(m.affect.difference$eatenQuant, 
                                         levels=c("0%", "10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%"))
ggplot(m.affect.difference, aes(x=eatenQuant, y=difference, color=quantifier)) +
  geom_point(size=3) + 
  geom_line(aes(group=quantifier)) +
  theme_bw() +
  scale_color_manual(values=c("#ff6666", "#66cccc", "gray"))

# Select only 30, 80, 100

m.affect.sample <- subset(m.affect, eatenQuant=="30%" | eatenQuant=="80%" | eatenQuant=="100%")

ggplot(m.affect.sample, aes(x=eatenQuant, y=probAffect, color=quantifier)) +
  geom_point(size=3) + 
  geom_line(aes(group=quantifier)) +
  theme_bw() +
  scale_color_manual(values=c("#ff6666", "#66cccc", "gray"))

###########
# Same case study for people: 10 cookies and upset
###########

d.summary.food.totalQuant <- summarySE(d.long, measurevar=c("rating"),
                                  groupvars=c("quantifier", "eatenQuant", "emotion", "totalQuant", "food"))
cookies.10 <- subset(d.summary.food.totalQuant, food=="cookies" & totalQuant ==10 & emotion=="upset")

ggplot(cookies.10, aes(x=eatenQuant, y=rating, color=quantifier)) +
  geom_point(size=3) +
  geom_line(aes(group=quantifier)) +
  geom_errorbar(aes(ymin=rating-ci, ymax=rating+ci), width=0.05) +
  theme_bw() +
  scale_color_manual(values=c("#ff6666", "#66cccc", "gray"))

