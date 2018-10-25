# Example Solutions for ggplot Workshop
# 
# Scientific Computing Day
# Visualization Workshop
# October 25, 2018
# 
# Matthew Turner
# Georgia State University
# 
# These are example solutions, yours may vary and still be right! Keep
# that in mind.
# 
# Good luck!

library(tidyverse)
library(gcookbook)

data(diamonds)

# 1a. Bar chart of cut

ggplot(data = diamonds, aes(x = cut)) + geom_bar()

# 1b. Bar chart of color

ggplot(data = diamonds, aes(x = color)) + geom_bar()

# 1c. Bar chart of carat (note this is NOT good!)

ggplot(data = diamonds, aes(x = carat)) + geom_bar()

# Un-numbered example I asked you to do to break geom_bar for state
# data:

changedata <- subset(uspopchange, rank(Change) >= 40) # Load data

ggplot(data = changedata, aes(x = Abb)) + geom_bar()

# What happens is that by default geom_bar() counts the number of
# values for each state (as is usual in a bar chart) and then reports
# that each state has one value. :-)

# 1d. Add color (fill!) to states data

ggplot(data = changedata, aes(x = Abb, y = Change, fill = Region)) +
  geom_bar(stat = "identity")

# 1e. Waiting time for Old Faithful

data(faithful)

ggplot(data = faithful, aes(x = waiting)) + geom_histogram()

# 2a. Convert previous to density plot:

ggplot(data = faithful, aes(x = waiting)) + geom_density()

# 2b. Birthweight versus smoking of mother

bwd <- MASS::birthwt
bwd$smoke <- factor(bwd$smoke) 

ggplot(data = bwd, aes(x = bwt, fill = smoke)) + 
  geom_density(alpha = 0.4)

# Tweaked x limits:

ggplot(data = bwd, aes(x = bwt, fill = smoke)) + 
  geom_density(alpha = 0.4) + 
  xlim(0, 5500)

# 3a. Height as a function of age:

data(heightweight)

ggplot(data = heightweight, aes(x = ageYear, y = heightIn, color = sex)) +
  geom_point()

# 3b. Change sex to shape, not color:

ggplot(data = heightweight, aes(x = ageYear, y = heightIn, shape = sex)) +
  geom_point()

# 3c. Solution is in the exercises since my example IS a solution. :-)

# 3d. Make a plot with too much going on! color/shape for sex and group:

hw <- heightweight
hw$weightGroup <- cut(hw$weightLb, breaks = c(-Inf, 100, Inf), labels = c("< 100", ">= 100"))

ggplot(data = hw, aes(x = ageYear, y = heightIn, shape = sex, color = weightGroup)) +
  geom_point(size = 4)

# Note that I manually set the size to make it look a litter better.
# 
# 3e. Add sex via color:

ggplot(data = hw, aes(x = ageYear, y = heightIn, size = weightLb, color = sex)) +
  geom_point(alpha = 0.50)

# 4a. 

ToothGrowth %>% select(supp, dose, len) %>% group_by(supp, dose) %>% summarize(length = mean(len)) -> tg

ggplot(data = tg, aes(x = dose, y = length, color = supp)) + 
  geom_line()

# 4b. Add points

ggplot(data = tg, aes(x = dose, y = length, color = supp)) + 
  geom_line() +
  geom_point()

# 4c. Change color to linetype

ggplot(data = tg, aes(x = dose, y = length, linetype = supp)) + 
  geom_line() +
  geom_point()

# 4d. Color and linetype for supp:

ggplot(data = tg, aes(x = dose, y = length, linetype = supp, color = supp)) + 
  geom_line() +
  geom_point()

# Please experiment with the solutions. All learning will come by
# trying things, breaking things, and looking for help to sort things
# out. Search engines can give you lots of advice on making different
# types of plots.

# EOF