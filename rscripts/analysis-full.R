library(ggplot2)
library(reshape2)
library(plyr)
source("~/Dropbox/Work/Grad_school/Research/Utilities/summarySE.R")
setwd("/Users/titlis/cogsci/projects/hyperbolicquantifiers/data/hyperbolicquantifiers/rscripts")
source("summarySE.R")

############################################################
# Affect priors
############################################################
affect.priors <- read.csv("../data/affectPriors/long_v2_60.csv")

## analyze p(upset) ~ eatenQuant
# higher upsetness ratings with increasing number of eaten items
m = lmer(upset ~ eatenQuant + (1|workerID) + (1|food), data=affect.priors)
summary(m)

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

#write.csv(affect.priors.long, "../data/affectPriors/affectPriors_v2_60_probit.csv")

affect.priors.summary <- summarySE(affect.priors.long, measurevar="probit", 
                                   groupvars=c("food", "totalQuant", "eatenQuant", "affect"))


#quartz()
ggplot(affect.priors.summary, aes(x=eatenQuant, y=probit)) +
  #geom_bar(stat="identity", color="black") +
  geom_point(size=2, color="black") +
  geom_line(aes(group=totalQuant), color="grey") +
  geom_errorbar(aes(ymin=probit-se, ymax=probit+se), width=0.05) +
  facet_grid(affect ~ food) +
  theme_bw()

#write.csv(affect.priors.summary, "../data/affectPriors/affectPriors_v2_60.csv")

#######
# PCA #
#######
comps <- princomp(data=affect.priors, ~ upset + happy + surprised + neutral, cor=FALSE, scores=TRUE)
summary(comps)$loadings
biplot(comps)
loadings(comps)
scores <- summary(comps)$scores
affect.priors.pca <- cbind(affect.priors, scores)
affect.priors.pca.long <-  melt(data=affect.priors.pca, id.vars=c("workerID", "gender", "age", "income", "language",
                                                                  "order", "personA", "personB",  "food", "totalQuant", "eatenQuant"),
                                measure.vars=c("Comp.1", "Comp.2", "Comp.3", "Comp.4"))
affect.priors.pca.summary <- summarySE(affect.priors.pca.long, measurevar="value",
                                       groupvars=c("food", "totalQuant", "eatenQuant", "variable"))

ggplot(affect.priors.pca.summary, aes(x=eatenQuant, y=value)) +
  #geom_bar(stat="identity", color="black") +
  geom_point(size=2, color="black") +
  geom_line(aes(group=totalQuant), color="grey") +
  geom_errorbar(aes(ymin=value-se, ymax=value+se), width=0.05) +
  facet_grid(variable ~ food) +
  theme_bw()

#===== check if normally distributed
ggplot(affect.priors.pca, aes(x=Comp.3)) +
  geom_histogram(binwidth=0.05)

#===== z-score
scores.z <- scale(scores)
affect.priors.pca.z <- cbind(affect.priors, scores.z)
affect.priors.pca.z.long <-  melt(data=affect.priors.pca.z, id.vars=c("workerID", "gender", "age", "income", "language",
                                                                      "order", "personA", "personB",  "food", "totalQuant", "eatenQuant"),
                                  measure.vars=c("Comp.1", "Comp.2", "Comp.3", "Comp.4"))
affect.priors.pca.z.summary <- summarySE(affect.priors.pca.z.long, measurevar="value",
                                         groupvars=c("food", "totalQuant", "eatenQuant", "variable"))

ggplot(affect.priors.pca.z.summary, aes(x=eatenQuant, y=value)) +
  #geom_bar(stat="identity", color="black") +
  geom_point(size=2, color="black") +
  geom_line(aes(group=totalQuant), color="grey") +
  geom_errorbar(aes(ymin=value-se, ymax=value+se), width=0.05) +
  facet_grid(variable ~ food) +
  theme_bw()
#========== probit
scores.probit <- pnorm(scores.z)
affect.priors.pca.probit <- cbind(affect.priors, scores.probit)
affect.priors.pca.probit.long <-  melt(data=affect.priors.pca.probit, id.vars=c("workerID", "gender", "age", "income", "language",
                                                                                "order", "personA", "personB",  "food", "totalQuant", "eatenQuant"),
                                       measure.vars=c("Comp.1", "Comp.2", "Comp.3", "Comp.4"))
affect.priors.pca.probit.summary <- summarySE(affect.priors.pca.probit.long, measurevar="value",
                                              groupvars=c("food", "totalQuant", "eatenQuant", "variable"))

ggplot(affect.priors.pca.probit.summary, aes(x=eatenQuant, y=value)) +
  #geom_bar(stat="identity", color="black") +
  geom_point(size=2, color="black") +
  geom_line(aes(group=totalQuant), color="grey") +
  geom_errorbar(aes(ymin=value-se, ymax=value+se), width=0.05) +
  facet_grid(variable ~ food) +
  theme_bw()


#write.csv(affect.priors.pca.probit.summary, "../data/affectPriors/affectPriors_v2_pca_probit_means.csv")

##########################################################################
# Hyperbole judgments
##########################################################################
food <- read.csv("../data/hyperbole/long_v3.csv")
food$food <- factor(food$food, levels=c("M&M's", "cookies", "pies"))
food$totalQuant <- factor(food$totalQuant)
food$eatenQuant <- factor(food$eatenQuant)

# Subject level
#quartz()
ggplot(food, aes(x=eatenQuant, y=probability, color=quantifier, shape=food)) +
  geom_point(size=2) +
  geom_line(aes(group=food)) +
  theme_bw() +
  facet_wrap(~workerID, ncol=4)

# Average across subjects
food.summary <- summarySE(food, measurevar="probability", 
                          groupvars=c("food", "quantifier", "eatenQuant"))

#quartz()
ggplot(food.summary, aes(x=eatenQuant, y=probability, color=quantifier)) +
  geom_point(size=2) +
  geom_line(aes(group=quantifier)) +
  geom_errorbar(aes(ymin=probability-se, ymax=probability+se), width=0.05) +
  theme_bw() +
  facet_grid(.~food) 

head(food)

##############################################
# Price priors
#############################################

priors.summary <- read.csv("../data//priors//priorMeans_v2.csv")
priors.summary$X <- NULL
priors.summary$quantifier <- "prior"
priors.summary$totalQuant <- NULL
priors.summary$food <- factor(priors.summary$food, levels=c("M&M's", "cookies", "pies"))

ggplot(priors.summary, aes(x=eatenQuant, y=probability)) +
  geom_point(size=2) +
  geom_line(aes(group=food)) +
  geom_errorbar(aes(ymin=probability-se, ymax=probability+se), width=0.05) +
  theme_bw() +
  facet_grid(.~food)

food.summary <- rbind(food.summary, priors.summary)

ggplot(food.summary, aes(x=eatenQuant, y=probability, color=quantifier)) +
  geom_point(size=2) +
  geom_line(aes(group=quantifier)) +
  geom_errorbar(aes(ymin=probability-se, ymax=probability+se), width=0.05) +
  theme_bw() +
  facet_grid(.~food) +
  scale_color_manual(values=c("#ff6666", "#66cccc", "gray"))

#write.csv(food.summary, "../data/hyperbole/hyperbole_prior_v2_means.csv")

############################################
## analyze p(all-eaten|"all") ~ prior expectation
############################################

rownames(priors.summary) = paste(priors.summary$food,priors.summary$eatenQuant)
tmp = ddply(priors.summary, .(food), summarize, expectation=sum(eatenQuant*probability))
head(tmp)
rownames(tmp) = tmp$food
food$prior_expectation = tmp[as.character(food$food),]$expectation

alleaten = subset(food, quantifier == "all" & eatenQuant == "10")
alleaten = droplevels(alleaten)
nrow(alleaten)

# log odds of all items eaten increases with increasing expectation of prior distribution (ie decreases with decreasing expectation)
m = lmer(probability ~ prior_expectation + (1|workerID),data=alleaten)
summary(m)

############################################
# Affect ratings
############################################


affect <- read.csv("../data/hyperbole-affect/long_v4.csv")
# drop rows that contain null value
affect <- subset(affect, surprised!="null")

affect$eatenQuant <- factor(affect$eatenQuant)
affect.long <- melt(data=affect, id.vars=c("workerID", "gender", "age", "income", "language", "order", "personA", "personB",
                                           "food", "totalQuant", "eatenQuant", "quantifier"),
                    measure.vars=c("upset", "happy", "surprised", "neutral"))

colnames(affect.long)[13] <- "affect"
colnames(affect.long)[14] <- "probAffect"

## analyze upsetness ratings as a function of quantifier for cases of not all items eaten
head(affect.long)
nrow(affect.long)
dd = subset(affect.long, eatenQuant != 10 & affect == "upset" & quantifier != "none") # exclude 1394 cases of all items eaten, non-upsetness affect, and "none", to get only not all items eaten, upsetness, and some/all
nrow(dd)
dd = droplevels(dd)
summary(dd)

m = lmer(probAffect ~ quantifier + eatenQuant + (1+quantifier+ eatenQuant|workerID) + (1|food), data=dd)
summary(m)

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
affect.summary$quantifier <- factor(affect.summary$quantifier, levels=c("all", "some", "none"))
ggplot(affect.summary, aes(x=eatenQuant, y=difference, color=quantifier)) +
  geom_point(size=2) +
  geom_line(aes(group=quantifier)) +
  facet_grid(food~affect) +
  theme_bw()  +
  scale_color_manual(values=c("#ff6666", "#66cccc", "black"))

#================PCA using dimensions from priors
scores.posterior <- predict(comps, affect)
#### z score and pnorm
scores.posterior.probit <- pnorm(scale(scores.posterior))
affect.pca <- cbind(affect, scores.posterior.probit)
affect.pca.long <-  melt(data=affect.pca, id.vars=c("workerID", "gender", "age", "income", "language",
                                                    "order", "personA", "personB",  "food", 
                                                    "totalQuant", "eatenQuant", "quantifier"),
                         measure.vars=c("Comp.1", "Comp.2", "Comp.3", "Comp.4"))


affect.pca.summary <- summarySE(affect.pca.long, measurevar="value",
                                groupvars=c("food", "totalQuant", "eatenQuant", "quantifier", "variable"))

affect.pca.summary$quantifier <- factor(affect.pca.summary$quantifier, levels=c("all", "some", "none"))
ggplot(affect.pca.summary, aes(x=eatenQuant, y=value, color=quantifier)) +
  #geom_bar(stat="identity", color="black") +
  geom_point(size=2) +
  geom_line(aes(group=quantifier)) +
  geom_errorbar(aes(ymin=value-se, ymax=value+se), width=0.05) +
  facet_grid(variable ~ food) +
  theme_bw() +
  scale_color_manual(values=c("#ff6666", "#66cccc", "black"))

#############################################################
# FIT MODEL
#############################################################

r.tables <- data.frame(modelName=NULL, r = NULL)
f.names <- read.csv("../model/parsed_outputs_PCA_mixedGoals_freeParams/filenames.txt", header=FALSE)
for (name in f.names$V1) {
  model <- read.csv(paste("../model/parsed_outputs_PCA_mixedGoals_freeParams/", name, sep=""))
  model$food <- factor(model$food, levels=c("M&M's", "cookies", "pies"))
  model$eatenQuant <- factor(model$eatenQuant)
  model.state <- aggregate(data=model, probability ~ food + quantifier + eatenQuant, FUN=sum)
  colnames(model.state)[4] <- "stateProb"
  comp.state <- join(model.state, food.summary, by=c("food", "quantifier", "eatenQuant"))
  cor <- with(comp.state, cor(stateProb, probability))
  r.table <- data.frame(modelName=name, r=cor)
  r.tables <- rbind(r.tables, r.table)
}

ggplot(r.tables, aes(x=r)) +
  geom_histogram() +
  theme_bw()

r.tables <- r.tables[with(r.tables, order(-r, modelName)), ]
best.model <- as.character(r.tables[1,1])

model <- read.csv(paste("../model/parsed_outputs_PCA_mixedGoals_freeParams/", best.model, sep=""))
model$food <- factor(model$food, levels=c("M&M's", "cookies", "pies"))
model$eatenQuant <- factor(model$eatenQuant)
model.state <- aggregate(data=model, probability ~ food + quantifier + eatenQuant, FUN=sum)
colnames(model.state)[4] <- "stateProb"

ggplot(model.state, aes(x=eatenQuant, y=stateProb, color=quantifier)) +
  geom_point(size=2) +
  geom_line(aes(group=quantifier)) +
  facet_grid(.~food) +
  theme_bw()

#####################
# Plot with human data
#####################
model.state$sd <- 0
model.state$se <- 0
model.state$ci <- 0
model.state$N <- 0
model.state$type <- "model"
colnames(food.summary)[5] <- "stateProb"
food.summary$type <- "human"

combined.state <- rbind(model.state, food.summary)
combined.state$color <- "interpretation"

priors.summary.all <- priors.summary
priors.summary.some <- priors.summary
colnames(priors.summary.all)[4] <- "stateProb"
colnames(priors.summary.some)[4] <- "stateProb"
priors.summary.all$quantifier <- "all"
priors.summary.some$quantifier <- "some"
priors.summary.all$type <- "prior"
priors.summary.some$type <- "prior"
priors.summary.all$color <- "prior"
priors.summary.some$color <- "prior"
combined.state <- rbind(combined.state, priors.summary.all, priors.summary.some)

combined.state$group <- paste(combined.state$quantifier, combined.state$type)

ggplot(subset(combined.state, quantifier == "all"), aes(x=eatenQuant, y=stateProb, color=type, shape=type)) +
  geom_point(size=2) +
  geom_errorbar(aes(ymin=stateProb-se, ymax=stateProb+se), width=0.05) +
  geom_line(aes(group=group, linetype=type)) +
  facet_grid(. ~food) +
  theme_bw() +
  xlab("Number of items eaten") +
  ylab("Probability") +
  scale_color_manual(values=c("#08306b", "#fc9272", "gray"), name="") +
  scale_linetype_manual(values=c(1, 2, 1), guide="none") +
  scale_shape_discrete(guide="none") +
  theme(legend.position=c(0.1, 0.75), legend.text = element_text(size=10),
        panel.grid.minor=element_blank(), panel.grid.major=element_blank())
  #ggtitle("Figure 1")

##############################
# Summary literal / non literal all
##############################
combined.state.all.literal <- subset(combined.state, quantifier == "all" & eatenQuant =="10")

ggplot(combined.state.all.literal, aes(x=type, y=stateProb, fill=type)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  facet_grid(.~food) +
  theme_bw()

#############################
# Affect PCA
#############################

model.pc1 <- aggregate(data=model, probability ~  food + quantifier + eatenQuant + pc1, FUN=sum)
model.pc1 <- subset(join(model.pc1, model.state, by=c("food", "quantifier", "eatenQuant")), pc1==1)
model.pc1$probAffect <- model.pc1$probability / model.pc1$stateProb
colnames(model.pc1)[4] <- "affect"
model.pc1$affect <- "pc1"

#quartz()
ggplot(model.pc1, aes(x=eatenQuant, y=probAffect, color=quantifier)) +
  geom_point(size=2) +
  geom_line(aes(group=quantifier)) +
  facet_grid(.~food) +
  theme_bw()

##########################
# Correlations of first affect PC
##########################
human.pc1 <- subset(affect.pca.summary, variable=="Comp.1" & quantifier != "none")
model.pc1 <- subset(model.pc1, eatenQuant != "0")
compare.pc1 <- join(human.pc1, model.pc1, by=c("food", "quantifier", "eatenQuant"))
ggplot(compare.pc1, aes(x=probAffect, y=value, color=quantifier)) +
  geom_point() +
  theme_bw()
with(compare.pc1, cor.test(value, probAffect))
with(subset(compare.pc1, quantifier=="all"), cor.test(value, probAffect))
with(subset(compare.pc1, quantifier=="some"), cor.test(value, probAffect))

##########################
# Plot with human
##########################
human.pc1$totalQuant <- NULL
human.pc1$variable <- NULL
human.pc1$type <- "human"
colnames(human.pc1)[5] <- "probAffect"
model.pc1$affect <- NULL
model.pc1$probability <- NULL
model.pc1$stateProb <- NULL

combined.pc1 <- rbind(human.pc1, model.pc1)
combined.pc1$group <- paste(combined.pc1$type, combined.pc1$quantifier)
combined.pc1$food <- factor(combined.pc1$food, levels=c("M&M's", "cookies", "pies"))
ggplot(combined.pc1, aes(x=eatenQuant, y=probAffect, color=quantifier)) +
  geom_point(size=2) +
  geom_errorbar(aes(ymin=probAffect-se, ymax=probAffect+se), width=0.05) +
  geom_line(aes(group=group, linetype=quantifier)) +
  facet_grid(food ~ type) +
  theme_bw()

######################
# Add affect priors
######################
affect.priors.pca.probit.summary.pc1 <- subset(affect.priors.pca.probit.summary, variable=="Comp.1")
affect.priors.pca.probit.summary.pc1$quantifier <- "prior"
affect.priors.pca.probit.summary.pc1$variable <- NULL
affect.priors.pca.probit.summary.pc1$totalQuant <- NULL
colnames(affect.priors.pca.probit.summary.pc1)[4] <- "probAffect"
affect.priors.pca.probit.summary.pc1$type <- "human"
affect.priors.pc1 <- affect.priors.pca.probit.summary.pc1
affect.priors.pca.probit.summary.pc1$type <- "model"
affect.priors.pc1 <- rbind(affect.priors.pc1, affect.priors.pca.probit.summary.pc1)
affect.priors.pc1$group <- paste(affect.priors.pc1$type, affect.priors.pc1$quantifier)
combined.pc1 <- rbind(combined.pc1, affect.priors.pc1)

ggplot(combined.pc1, aes(x=eatenQuant, y=probAffect, color=quantifier)) +
  geom_point(size=2) +
  geom_errorbar(aes(ymin=probAffect-se, ymax=probAffect+se), width=0.05) +
  geom_line(aes(group=group, linetype=quantifier)) +
  facet_grid(food ~ type) +
  theme_bw()

combined.pc1$label <- ifelse(combined.pc1$quantifier == "all" & combined.pc1$eatenQuant =="10", "all", 
                             ifelse(combined.pc1$quantifier == "all" & combined.pc1$eatenQuant != "10", "all",
                                    ifelse(combined.pc1$quantifier == "prior" & combined.pc1$eatenQuant == "10", "prior",
                                           ifelse(combined.pc1$quantifier == "prior" & combined.pc1$eatenQuant != "10", "prior", "other"))))
combined.pc1.noSome.nonliteral <- subset(combined.pc1, label != "other" & eatenQuant != "10" & group != "model prior")
combined.pc1.priorComp <- summarySE(combined.pc1.noSome.nonliteral, measurevar="probAffect", 
                                    groupvars=c("food", "group"))

combined.pc1.priorComp$group <- factor(combined.pc1.priorComp$group, levels=c("human prior", "human all", "model all"),
                                       labels=c("prior", "human", "model"))

ggplot(combined.pc1.priorComp, aes(x=group, y=probAffect, fill=group)) +
  geom_bar(stat="identity", color="black", position="dodge") +
  geom_errorbar(aes(ymin=probAffect-se, ymax=probAffect+se)) +
  #geom_point() +
  facet_grid(.~food) +
  theme_bw()
#########################
# Plot mean affect across eaten quantities
#########################
combined.pc1.summary <- summarySE(combined.pc1, measurevar="probAffect", groupvars=c("food", "quantifier", "type"))
ggplot(combined.pc1.summary, aes(x=food, y=probAffect, fill=quantifier)) +
  geom_bar(color="black", stat="identity", position=position_dodge()) +
  geom_errorbar(aes(ymin=probAffect-se, ymax=probAffect+se), position=position_dodge(0.9), width=0.2) +
  theme_bw() +
  facet_grid(.~type)

###################
# FIGURE 2 CUNY
###################


combined.pc1.summary.notAll <- summarySE(subset(combined.pc1, eatenQuant != "10"), measurevar="probAffect", groupvars=c("food", "quantifier", "type"))
combined.pc1.summary.notAll$quantifier <- factor(combined.pc1.summary.notAll$quantifier, levels=c("some", "all"))
ggplot(combined.pc1.summary.notAll, aes(x=quantifier, y=probAffect, fill=type)) +
  geom_bar(color="black", stat="identity", position=position_dodge()) +
  geom_errorbar(aes(ymin=probAffect-ci, ymax=probAffect+ci), position=position_dodge(0.9), width=0.2) +
  theme_bw() +
  facet_grid(type~food) +
  scale_fill_manual(values=c("#045a8d", "#fcbba1"), name="", guide=FALSE) +
  xlab("") +
  ylab("Probability of negative affect")
  
combined.pc1.summary.notAll.human  <- subset(combined.pc1.summary.notAll, type=="human")
colnames(combined.pc1.summary.notAll.human)[5] <- "humanProb"
combined.pc1.summary.notAll.model  <- subset(combined.pc1.summary.notAll, type=="model")
colnames(combined.pc1.summary.notAll.model)[5] <- "modelProb"
combined.pc1.summary.notAll.wide <- join(combined.pc1.summary.notAll.human, combined.pc1.summary.notAll.model,
                                         by=c("food", "quantifier"))
with(combined.pc1.summary.notAll.wide, cor.test(humanProb, modelProb))
ggplot(combined.pc1.summary.notAll.wide, aes(x=modelProb, y=humanProb, color=quantifier)) +
  geom_point() +
  theme_bw()