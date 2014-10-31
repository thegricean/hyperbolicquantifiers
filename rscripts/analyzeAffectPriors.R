food.affect <- read.csv("../data/affectPriors/long_80_corrected.csv")
food.affect$totalQuant <- factor(food.affect$totalQuant)
food.affect$eatenQuant <- factor(food.affect$eatenQuant)
food.affect.summary <- summarySE(food.affect, measurevar="probAffect", 
                                 groupvars=c("food", "totalQuant", "eatenQuant"))

ggplot(food.affect.summary, aes(x=eatenQuant, y=probAffect, fill=totalQuant)) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymin=probAffect-se, ymax=probAffect+se), width=0.2) +
  facet_grid(food ~ totalQuant) +
  theme_bw()

write.csv(food.affect.summary, "../data/affectPriors/means_80_corrected.csv")