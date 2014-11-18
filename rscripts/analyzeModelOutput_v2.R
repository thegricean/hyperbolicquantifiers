# ##################
# # Single case of 10 cookies
# ##################
# 
# m <- read.csv("../model/output/half-baked.csv")
# m$eatenQuant <- factor(m$eatenQuant)
# 
# # Predictions for eaten
# m.eaten <- aggregate(data=m, modelProb ~ quantifier + eatenQuant, FUN=sum)
# colnames(m.eaten)[3] <- "quantityProb"
# ggplot(m.eaten, aes(x=eatenQuant, y=quantityProb, color=quantifier)) +
#   geom_point(size=2) + 
#   geom_line(aes(group=quantifier)) +
#   theme_bw() 
# 
# #####
# # Affect
# #####
# 
# a.priors <- read.csv("../data/affectPriors/affectPriors_v2.csv")
# 
# # Predictions for upset
# m.upset <- aggregate(data=m, modelProb ~ quantifier + eatenQuant + upset, FUN=sum)
# m.upset <- join(m.upset, m.eaten, by=c("quantifier", "eatenQuant"))
# m.upset$probAffect <- m.upset$modelProb / m.upset$quantityProb
# 
# a.upset <- subset(a.priors, affect=="upset" & food=="cookies")
# a.upset$X <- NULL
# a.upset$food <- NULL
# a.upset$affect <- NULL
# a.upset$totalQuant <- NULL
# a.upset$N <- NULL
# a.upset$sd <- NULL
# a.upset$se <- NULL
# a.upset$ci <- NULL
# a.upset$quantifier <- "prior"
# a.upset$upset <- 1
# a.upset$modelProb <- "na"
# a.upset$quantityProb <- "na"
# 
# m.upset <- rbind(m.upset, a.upset)
# ggplot(subset(m.upset, upset==1), aes(x=eatenQuant, y=probAffect, color=quantifier)) +
#   geom_point(size=2) + 
#   geom_line(aes(group=quantifier)) +
#   theme_bw() +
#   scale_color_manual(values=c("#ff6666", "#66cccc", "gray"))
# 
# # Join with prior and subtract
# m.upset <- aggregate(data=m, modelProb ~ quantifier + eatenQuant + upset, FUN=sum)
# m.upset <- join(m.upset, m.eaten, by=c("quantifier", "eatenQuant"))
# m.upset$probAffect <- m.upset$modelProb / m.upset$quantityProb
# colnames(a.upset)[2] <- "prior"
# m.upset <- join(m.upset, a.upset, by=c("eatenQuant"))
# m.upset$difference <- m.upset$probAffect - m.upset$prior
# ggplot(subset(m.upset, upset==1), aes(x=eatenQuant, y=difference, color=quantifier)) +
#   geom_point(size=2) +
#   geom_line(aes(group=quantifier)) +
#   theme_bw()
# 
# # Predictions for happiness
# m.happy <- aggregate(data=m, modelProb ~ quantifier + eatenQuant + happy, FUN=sum)
# m.happy <- join(m.happy, m.eaten, by=c("quantifier", "eatenQuant"))
# m.happy$probAffect <- m.happy$modelProb / m.happy$quantityProb
# ggplot(subset(m.happy, happy==1), aes(x=eatenQuant, y=probAffect, color=quantifier)) +
#   geom_point(size=2) + 
#   geom_line(aes(group=quantifier)) +
#   theme_bw() 
# 
# # Predictions for surprise
# m.surprised <- aggregate(data=m, modelProb ~ quantifier + eatenQuant + surprised, FUN=sum)
# m.surprised <- join(m.surprised, m.eaten, by=c("quantifier", "eatenQuant"))
# m.surprised$probAffect <- m.surprised$modelProb / m.surprised$quantityProb
# ggplot(subset(m.surprised, surprised==1), aes(x=eatenQuant, y=probAffect, color=quantifier)) +
#   geom_point(size=2) + 
#   geom_line(aes(group=quantifier)) +
#   theme_bw() 
#########################################
# Full predictions with means
#########################################
model <- read.csv("../model/models_full_output/means.csv")
model$food <- factor(model$food, levels=c("M&M's", "cookies", "pies"))
model$eatenQuant <- factor(model$eatenQuant)
model.state <- aggregate(data=model, probability ~ food + quantifier + eatenQuant, FUN=sum)
colnames(model.state)[4] <- "stateProb"

ggplot(model.state, aes(x=eatenQuant, y=stateProb, color=quantifier)) +
  geom_point(size=2) +
  geom_line(aes(group=quantifier)) +
  facet_grid(.~food) +
  theme_bw()

model.upset <- aggregate(data=model, probability ~  food + quantifier + eatenQuant + upset, FUN=sum)
model.upset <- subset(join(model.upset, model.state, by=c("food", "quantifier", "eatenQuant")), upset==1)
model.upset$probAffect <- model.upset$probability / model.upset$stateProb

ggplot(model.upset, aes(x=eatenQuant, y=probAffect, color=quantifier)) +
  geom_point(size=2) +
  geom_line(aes(group=quantifier)) +
  facet_grid(.~food) +
  theme_bw()

model.happy <- aggregate(data=model, probability ~  food + quantifier + eatenQuant + happy, FUN=sum)
model.happy <- subset(join(model.happy, model.state, by=c("food", "quantifier", "eatenQuant")), happy==1)
model.happy$probAffect <- model.happy$probability / model.happy$stateProb

ggplot(model.happy, aes(x=eatenQuant, y=probAffect, color=quantifier)) +
  geom_point(size=2) +
  geom_line(aes(group=quantifier)) +
  facet_grid(.~food) +
  theme_bw()


model.surprised <- aggregate(data=model, probability ~  food + quantifier + eatenQuant + surprised, FUN=sum)
model.surprised <- subset(join(model.surprised, model.state, by=c("food", "quantifier", "eatenQuant")), surprised==1)
model.surprised$probAffect <- model.surprised$probability / model.surprised$stateProb

ggplot(model.surprised, aes(x=eatenQuant, y=probAffect, color=quantifier)) +
  geom_point(size=2) +
  geom_line(aes(group=quantifier)) +
  facet_grid(.~food) +
  theme_bw()



###########################################
# Full predictions with boostrap
###########################################
models.state <- data.frame(food=NULL, quantifier=NULL, eatenQuant=NULL, stateProb=NULL, modelNum=NULL)
for (i in 1:1000) {
  model <- read.csv(paste("../model/models_basic_output/", i, ".csv", sep=""))
  model$food <- factor(model$food, levels=c("M&M's", "cookies", "pies"))
  model$eatenQuant <- factor(model$eatenQuant)
  model.state <- aggregate(data=model, probability ~ food + quantifier + eatenQuant, FUN=sum)
  colnames(model.state)[4] <- "stateProb"
  model.state$modelNum <- i
  models.state <- rbind(models.state, model.state)
}

models.state.summary <- summarySE(models.state, measurevar="stateProb", groupvars=c("food", "quantifier", "eatenQuant"))

ggplot(models.state.summary, aes(x=eatenQuant, y=stateProb, color=quantifier)) +
  geom_point(size=2) +
  geom_errorbar(aes(ymin=stateProb-ci, ymax=stateProb+ci), width=0.2)+
  geom_line(aes(group=quantifier)) +
  facet_grid(.~food) +
  theme_bw()

models.upset <- data.frame(food=NULL, quantifier=NULL, eatenQuant=NULL, probability=NULL, probAffect=NULL, stateProb=NULL, modelNum=NULL)
for (i in 1:1000) {
  model <- read.csv(paste("../model/models_basic_output/", i, ".csv", sep=""))
  model$food <- factor(model$food, levels=c("M&M's", "cookies", "pies"))
  model$eatenQuant <- factor(model$eatenQuant)
  model.upset <- aggregate(data=model, probability ~  food + quantifier + eatenQuant + upset, FUN=sum)
  model.upset <- subset(join(model.upset, model.state, by=c("food", "quantifier", "eatenQuant")), upset==1)
  model.upset$probAffect <- model.upset$probability / model.upset$stateProb
  model.upset$modelNum <- i
  models.upset <- rbind(models.upset, model.upset)
}

