# Read priors data
food.priors <- read.csv("../data/priors/long_50.csv")
food.priors$food <- factor(food.priors$food, levels=c("blueberries", "M&M's", "strawberries", "cookies", "bananas", "pies"))
food.priors$totalQuant <- factor(food.priors$totalQuant)
food.priors$eatenQuantLabels <- food.priors$eatenQuant * 10
food.priors$eatenQuant <- factor(food.priors$eatenQuant)
food.priors$eatenQuantLabels <- factor(food.priors$eatenQuantLabels)

# Average across subjects
food.priors.summary <- summarySE(food.priors, measurevar="probability", 
                                 groupvars=c("food", "totalQuant", "eatenQuantLabels"))

# Visualize items/quantities
ggplot(food.priors.summary, aes(x=eatenQuantLabels, y=probability, fill=totalQuant)) +
  facet_grid(food~totalQuant) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymax=probability+se, ymin=probability-se), width=0.2) +
  theme_bw() +
  xlab("Percentage eaten (%)") +
  scale_fill_discrete(guide=FALSE) +
  ggtitle("Priors")