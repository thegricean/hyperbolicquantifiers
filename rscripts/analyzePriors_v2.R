# Read priors data
food.priors <- read.csv("../data/priors/long_v2.csv")
food.priors$food <- factor(food.priors$food, levels=c("M&M's", "cookies", "pies"))
food.priors$totalQuant <- factor(food.priors$totalQuant)
#food.priors$eatenQuantLabels <- food.priors$eatenQuant * 10
food.priors$eatenQuant <- factor(food.priors$eatenQuant)
#food.priors$eatenQuantLabels <- factor(food.priors$eatenQuantLabels)

# Average across subjects
food.priors.summary <- summarySE(food.priors, measurevar="probability", 
                                 groupvars=c("food", "totalQuant", "eatenQuant"))

#write.csv(food.priors.summary, "../data/priors/priorMeans_v2.csv")

# Visualize items/quantities
ggplot(food.priors.summary, aes(x=eatenQuant, y=probability, fill=totalQuant)) +
  facet_grid(food~totalQuant) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymax=probability+se, ymin=probability-se), width=0.2) +
  theme_bw() +
  xlab("Number eaten") +
  scale_fill_discrete(guide=FALSE) +
  ggtitle("Priors")