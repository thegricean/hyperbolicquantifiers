# Read priors data
food.priors <- read.csv("../data/priors/long_30.csv")
food.priors$totalQuant <- factor(food.priors$totalQuant)
food.priors$eatenQuantLabels <- ifelse(food.priors$eatenQuant==10, food.priors$eatenQuant, 
                                       food.priors$eatenQuant * 10)
food.priors$eatenQuant <- factor(food.priors$eatenQuant)

# Average across subjects
food.priors.summary <- summarySE(food.priors, measurevar="probability", 
                                 groupvars=c("food", "totalQuant", "eatenQuant"))

# Visualize individaul items/quantities
food.example <- "blueberries"
food.priors.example <- subset(food.priors.summary, food==food.example)
ggplot(food.priors.example, aes(x=eatenQuant, y=probability, fill=totalQuant)) +
  facet_grid(.~totalQuant) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymax=probability+se, ymin=probability-se), width=0.2) +
  theme_bw()