d <- read.csv("../data/hyperbole-affect/elicitAffect_long_emoWords.csv")
d.trimmed <- subset(d, affect!="none")

tb <- table(state)
statefac <- factor(state,
                   levels = names(tb[order(tb, decreasing = TRUE)]))
d$affect <- factor(d$affect, levels=names(d[order(d, decreasing = TRUE)]))

d.hyperbolic.count <- count(subset(d.trimmed, condition=="hyperbolic")$affect)
d.hyperbolic.count$x <- factor(d.hyperbolic.count$x, levels=names())
d.hyperbolic.count$newOrder <- reorder(d.hyperbolic.count$x, d.hyperbolic.count$freq)
  
  factor(d.hyperbolic.count$x, levels=)

d$affect <- reorder(d$affect, count$subset(d, condition=="hyperbolic"))
ggplot(d.trimmed, aes(x=affect)) +
  geom_histogram() +
  facet_grid(condition~.) +
  theme_bw()

count(d$affect)
