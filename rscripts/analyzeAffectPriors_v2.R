food.affect <- read.csv("../data/affectPriors/long_v2.csv")
food.affect$totalQuant <- factor(food.affect$totalQuant)
food.affect$eatenQuant <- factor(food.affect$eatenQuant)
food.affect.long <- melt(data=food.affect, id.vars=c("workerID", "gender", "age", "income", "language",
                                                     "order", "personA", "personB",  "food", "totalQuant", "eatenQuant"),
                         measure.vars=c("upset", "happy", "surprised", "neutral"))
colnames(food.affect.long)[12] <- "affect"
colnames(food.affect.long)[13] <- "probAffect"

food.affect.summary <- summarySE(food.affect.long, measurevar="probAffect", 
                                 groupvars=c("food", "totalQuant", "eatenQuant", "affect"))

ggplot(food.affect.summary, aes(x=eatenQuant, y=probAffect, fill=totalQuant)) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymin=probAffect-se, ymax=probAffect+se), width=0.2) +
  facet_grid(food ~ affect) +
  theme_bw()

write.csv(food.affect.summary, "../data/affectPriors/affectPriors_v2.csv")
