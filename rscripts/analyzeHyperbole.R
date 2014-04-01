summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
  require(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean" = measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}

# Read priors data
food <- read.csv("../data/hyperbole/long_40.csv")
food$food <- factor(food$food, levels=c("blueberries", "M&M's", "strawberries", "cookies", "bananas", "pies"))
food$totalQuant <- factor(food$totalQuant)
food$eatenQuantLabels <- food$eatenQuant * 10
food$eatenQuant <- factor(food$eatenQuant)
food$eatenQuantLabels <- factor(food$eatenQuantLabels)

# Average across subjects
food.summary <- summarySE(food, measurevar="probability", 
                                 groupvars=c("food", "totalQuant", "quantifier", "eatenQuantLabels"))

# "some"
food.some.summary <- subset(food.summary, quantifier=="some")

# Visualize items/quantities
ggplot(food.some.summary, aes(x=eatenQuantLabels, y=probability, fill=totalQuant)) +
  facet_grid(food~totalQuant) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymax=probability+se, ymin=probability-se), width=0.2) +
  theme_bw() +
  xlab("Percentage eaten (%)") +
  scale_fill_discrete(guide=FALSE) +
  ggtitle("'some of the'")

# "all"
food.all.summary <- subset(food.summary, quantifier=="all")

# Visualize items/quantities
ggplot(food.all.summary, aes(x=eatenQuantLabels, y=probability, fill=totalQuant)) +
  facet_grid(food~totalQuant) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymax=probability+se, ymin=probability-se), width=0.2) +
  theme_bw() +
  xlab("Percentage eaten (%)") +
  scale_fill_discrete(guide=FALSE) +
  ggtitle("'all of the'")