#            Exercises for ggplot2
#
#              Matthew D. Turner
#    Presented at the Visualization Workshop
#           Scientific Computing Day
#           Georgia State University
#               25 October 2018

# This file contains exercises that use ggplot2 to make elementary
# figures.
#
# Setup:

library(tidyverse)
library(gcookbook)



# 1. Histograms and Bar Charts
#
# First we make a bar chart of the cuts of diamonds:

data(diamonds)

# Look at the first few entries of the diamonds data set. How do you
# do that? (You can refer back to the demonstrations file for help!)
#
# Hint: to get help from R, use the ? symbol, like this:

?head

# 1a. Make a bar chart for the cut variable in the diamonds data set,
# set x aesthetic to be cut, then use: geom_bar()



# Did it work?
#
# Hints: Remember you need to (1) use the ggplot() function, (2)
# inside of the ggplot function you need to use aes() to set the
# aesthetics and you need to tell it which data to use: data = ____.
# Then you need to add on your geom function. Did you remember all of
# that? If all else fails, ask your neighbor! You can also look at the
# histogram example (after 1c, below) for a hint.

# 1b. Now change the previous exercise to make a bar chart of the
# color variable.



# 1c. Now change the previous exercises to make a bar chart of the
# carat variable:



# Note that this does not look right. Why?
#
# What kind of variable is carat?
#
# Carat is a continuous variable, so bar charts are not right. For
# these you should use histograms, which can be obtained as follows:

ggplot(data = diamonds, aes(x = carat)) + geom_histogram()

# Histograms take continuous variables and break their range of values
# into bins, then makes a bar for each bin. Officially, histograms
# should have bars that touch, while bar charts (representing discrete
# categories) should have bars that do NOT touch.
#
# Now we grab some population change data by state. This has all 50
# states, so we just grab the top 10 for simplicity. (I do this part
# for you.)

changedata <- subset(uspopchange, rank(Change) >= 40) # Grab top 10 states
head(changedata)

# Now, let's make a bar chart of Change (y-axis) by Abb (x-axis):

ggplot(data = changedata, aes(x = Abb, y = Change)) +
  geom_bar(stat = "identity")

# Note that we use: stat = "identity" to tell ggplot to use the Change
# numbers in place of the counts. What would happen if you just
# assigned x to Abb and left geom_bar() as we used it previously? Try
# it:



# 1d. Add color to the bars (using fill) to indicate region:



# Did it work? If not, did you remember to capitalize the variable
# name?
#
# One final point: it might be nice to put the bars in ascending order
# by the amount of the change. This is a little harder, but not much:

ggplot(data = changedata, aes(x = reorder(Abb, Change), y = Change, fill = Region)) +
  geom_bar(stat = "identity")

# Note that this last example tells you what to do for the color if
# you had trouble with that! The function reorder() takes the first
# variable and orders it by the second. See:

?reorder

# for more.
#
# Now we turn to the Old Faithful geyser data:

?faithful
data("faithful")
head(faithful)

# 1e. Geyser Data - Make a histogram of waiting time for the Old
# Faithful geyser data:




# 2. Density Plots
#
# Density plots are basically the same as histograms, so you can just
# drop geom_density in for geom_histogram.
#
# 2a. Convert the plot in exercise 1e into a density plot:



# Sometimes people like density plots with some fill to make it look
# better. Here is how to do that. To make it a little different we use
# the eruption time, not the waiting time:

ggplot(data = faithful, aes(x = eruptions)) +
  geom_density(fill = "blue", alpha = 0.30) +
  xlim(0, 6)

# There are some tweaks here that are new: we set the fill color not
# to an aesthetic, but to a constant color. Second we set the alpha to
# a fixed value, too. That means we are making a color/alpha
# combination that looks good to us; not something that conveys
# information about a variable. Finally, I added a set of x limits,
# using the xlim() function. I think this makes it look better! These
# are the sorts of tweaks you learn over time.
#
# We can do multiple density plots if we like. Here we use the
# "birthwt" data set frol library MASS:

bwd <- MASS::birthwt            # Trick to load some data, not important
bwd$smoke <- factor(bwd$smoke)  # Convert smoke variable to factor
head(bwd)

# 2b. Make a density plot of birthweight (bwt) on x and fill using the
# variable smoke. Note that smoke is a variable indicating if the
# mother smoked while pregnant. To see both densities, you will need
# to set a FIXED level of alpha, like in my example. Do NOT set fill
# to a constant!




# 3. Scatterplots
#
# Let's look at the relationship between height, age, and sex.

data("heightweight")
head(heightweight)

# What is this data all about?

?heightweight

# 3a. Make a scatterplot -- geom_point() -- with the x-axis set to
# ageYear (note the capital "Y"), the y-axis set to heightIn, and
# color set to sex:



# 3b. Now convert the plot so that no color is used, but the shape of
# the points indicates sex:



# If we want to manually set the shapes we can do that, too. (Again,
# here is a hint for the previous problems):

ggplot(data = heightweight, aes(x = ageYear, y = heightIn, shape = sex)) +
  geom_point(size = 3) +
  scale_shape_manual(values = c(1, 2))

# As usual, here are the new tweaks I added: I set size to a constant
# of 3 (I picked it by trial and error) to make the symbols bigger.
# The values 1 and 2, used in the scale_shape_manual() function, were
# picked from a chart I found online of R plotting symbols.
#
# 3c. Experiment with my example code by changing the symbol values
# (the numbers 1 and 2). Stop when you get something you like!



# Now I am going to make a new variable. This will split the data into
# those over 100 pounds and those under:

hw <- heightweight   # Copy heightweight to a new variable

hw$weightGroup <- cut(hw$weightLb, breaks = c(-Inf, 100, Inf),
                      labels = c("< 100", ">= 100"))

head(hw)  # See our new variable?

# 3d. Now make a plot like the ones above with x-axis ageYear, y-axis
# heightIn, and then use the shape and fill to show the sex and the
# weightGroup. Your choice on what looks best. Make sure to use the
# new hw data set!



# Maybe you want to get the full weight information into the plot.
# Here is one way to do that. R will make a color gradient to
# represent the full range of weights:

ggplot(data = hw, aes(x = ageYear, y = heightIn, color = weightLb)) +
  geom_point()

# We can also use size (I set alpha to make the dots transparent for
# easier viewing):

ggplot(data = hw, aes(x = ageYear, y = heightIn, size = weightLb)) +
  geom_point(alpha = 0.50)

# 3e. Now make a plot that adds sex to the display using color:




# 4. Lines
#
# The last basic plot type we will cover is the line plot. This is a
# basic science plot. We will use some guinea pig tooth growth data. I
# will organize it for you:

?ToothGrowth

# This command makes a summary of the ToothGrowth data set. It uses
# several tools that come from the "tidyverse":

ToothGrowth %>% select(supp, dose, len) %>% group_by(supp, dose) %>%
                summarize(length = mean(len)) -> tg

tg  # Show the summarized data

# The data now shows supp (the supplement used, either orange juice,
# OJ, or ascorbic acid, VC) the dose of each supplement (0.5, 1, or 2
# units), and the observed length of the odontoblasts (the cells
# responsible for tooth growth). If you want to be constantly
# surprised by weird data, become a statistician!
#
# 4a. For the tg data set, make a plot with dose on the x-axis, length
# on the y-axis, and color for the supp. Use a geom_line() to make a
# line plot:



# 4b. Add points to the graph you just made. How do you think you will
# do that? Hint: it is easy and more or less obvious!



# Another aesthetic is "linetype".
#
# 4c. Change the plot from 4a to use linetype rather than color:



# 4d. Try using color AND linetype for supp:



# Here is a solution for the last problem that includes some
# additional tweaks for size. I am not suggesting that this is a good
# plot for serious work.

ggplot(data = tg, aes(x = dose, y = length, color = supp, linetype = supp)) +
  geom_line(lwd = 2) +
  geom_point(size = 6)

# Final Note: Obviously I cannot cover every type of plot. But you
# should be far enough along in playing with ggplot2 now that you can
# start to figure out how to find the infomation you need. Look online
# for lists of the geoms and use the cheat sheet. Google and other
# search engines do well with requests like "how do I make a _____ in
# ggplot?"
#
# Try the links in the slides and the comments of the files to learn
# more about the tweaks that you can use to make plots look right.
# Finally, make sure to look over the other materials provided with
# this workshop. There is a presentation showing how to work with
# Microsoft Office products, and an R code file showing how to make
# publication quality graphics.
#
# Good luck!

# EOF