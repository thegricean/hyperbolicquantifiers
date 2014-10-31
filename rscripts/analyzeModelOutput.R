m <- read.csv("../model/output/alloutput-notNone.csv")
m$food <- factor(m$food, levels=c("blueberries", "M&M's", "strawberries", "cookies", "bananas", "pies"))
m$totalQuant <- factor(m$totalQuant)
m$eatenQuant <- factor(m$eatenQuant)
m$affect <- factor(m$affect)
colnames(m)[6] <- "model"

m.some <- subset(m, quantifier=="some")
m.all <- subset(m, quantifier=="all")

ggplot(m.some, aes(x=eatenQuant, y=model, fill=affect)) +
  geom_bar(stat="identity", color="black") +
  facet_grid(food ~ totalQuant) +
  theme_bw()

ggplot(m.all, aes(x=eatenQuant, y=model, fill=affect)) +
  geom_bar(stat="identity", color="black") +
  facet_grid(food ~ totalQuant) +
  theme_bw()

# compare to human data
m.state <- aggregate(data=m, model ~ quantifier + food + totalQuant + eatenQuant, FUN=sum)

# Read priors data
food <- read.csv("../data/hyperbole/long_40.csv")
food$food <- factor(food$food, levels=c("blueberries", "M&M's", "strawberries", "cookies", "bananas", "pies"))
food$totalQuant <- factor(food$totalQuant)
food$eatenQuant <- factor(food$eatenQuant)
colnames(food)[13] <- "human"

# Average across subjects
food.summary <- summarySE(food, measurevar="human", 
                          groupvars=c("food", "totalQuant", "quantifier", "eatenQuant"))

# "all"
food.all.summary <- subset(food.summary, quantifier=="all")

# Visualize items/quantities
ggplot(food.all.summary, aes(x=eatenQuant, y=human)) +
  facet_grid(food~totalQuant) +
  geom_bar(stat="identity", color="black", fill="gray") +
  geom_errorbar(aes(ymax=human+se, ymin=human-se), width=0.2) +
  theme_bw() +
  xlab("Percentage eaten (%)") +
  scale_fill_discrete(guide=FALSE) +
  ggtitle("'all of the'")

compare <- join(food.summary, m.state, by=c("food", "totalQuant", "eatenQuant", "quantifier"))
with(compare, cor.test(human, model))
with(subset(compare, quantifier=="some"), cor.test(human, model))
with(subset(compare, quantifier=="all"), cor.test(human, model))

ggplot(compare, aes(x=model, y=human, color=eatenQuant, shape=food))+
  #geom_text(aes(label=eatenQuant), size=6) +
  geom_errorbar(aes(ymin=human-se, ymax=human+se), width=0.01, color="dark gray") +
  facet_grid(quantifier ~ totalQuant) +
  geom_point(size=3) +
  scale_color_brewer(palette="RdYlGn") +
  theme_bw()

### noisy literal model

m.noisy <- read.csv("../model/output/alloutput-noisyLiteral.csv")
m.noisy$food <- factor(m.noisy$food, levels=c("blueberries", "M&M's", "strawberries", "cookies", "bananas", "pies"))
m.noisy$totalQuant <- factor(m.noisy$totalQuant)
m.noisy$eatenQuant <- factor(m.noisy$eatenQuant)
colnames(m.noisy)[5] <- "model_noisy"

m.noisy.some <- subset(m.noisy, quantifier=="some")
m.noisy.all <- subset(m.noisy, quantifier=="all")

ggplot(m.noisy.some, aes(x=eatenQuant, y=model_noisy)) +
  geom_bar(stat="identity", color="black") +
  facet_grid(food ~ totalQuant) +
  theme_bw()

ggplot(m.noisy.all, aes(x=eatenQuant, y=model_noisy)) +
  geom_bar(stat="identity", color="black") +
  facet_grid(food ~ totalQuant) +
  theme_bw()

compare <- join(compare, m.noisy, by=c("food", "totalQuant", "eatenQuant", "quantifier"))
with(compare, cor.test(human, model_noisy))
with(subset(compare, quantifier=="some"), cor.test(human, model_noisy))
with(subset(compare, quantifier=="all"), cor.test(human, model_noisy))

ggplot(compare, aes(x=model_noisy, y=human, color=eatenQuant, shape=food))+
  #geom_text(aes(label=eatenQuant), size=6) +
  facet_grid(quantifier ~ totalQuant) +
  geom_point(size=3) +
  scale_color_brewer(palette="RdYlGn") +
  #geom_errorbar(aes(ymin=human-se, ymax=human+se), width=0.05) +
  theme_bw()