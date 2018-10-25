#             Overview of ggplot2
#
#              Matthew D. Turner
#   Presented at the Visualization Workshop
#           Georgia State University
#               25 October 2018

# ggplot2 is a sophisticated plotting system developed by Hadley
# Wickham and based on the "Grammar of Graphics" (developed by Leland
# Wilkinson). It provides a systematic way of building up graphical
# displays of data from elementary ideas and operations.

# Some additional help with ggplot2 can be found at:
#
# 1. https://tutorials.iq.harvard.edu/R/Rgraphics/Rgraphics.html
# 2. https://stats.idre.ucla.edu/r/seminars/ggplot2_intro/ (excellent!)
# 3. https://rpubs.com/hadley/ggplot2-layers (advice on layering plots)
#
# More advanced examples can be found in:
#
# http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html

# Set up R to use ggplot:

set.seed(1001)         # Optional (makes the plots match expectations)
library(tidyverse)     # Required
#library(gcookbook)     # For some data sets we may use



# Part I -- Material from the Slide Presentation
#
# The following code makes the examples from the slide presentation.
# This section will focus on examples that are scatterplots. The
# scatterplot is the most basic plot to start with (with the possible
# exception of the histogram). It uses two aesthetics in the most
# basic form, the the x position and y position for each point in the
# figure are mapped to two different variables in your data set.

data("diamonds")   # Load the "diamonds" data set (included w/ggplot2)
head(diamonds)     # Look at the first few rows of the data
dim(diamonds)      # What is the size? (53940 rows and 10 variables)

# Because diamonds is a very large data set (and my demonstration computer
# is a little slow) I will take a random sample of just 5000 data points:

small_diamonds <- sample_n(diamonds, size = 5000)  # sample_n is from dplyr

# Here is how you probably make this plot already:

plot(small_diamonds$carat, small_diamonds$price, pch = 16)

# Here is the ggplot equivalent:

pvc <- ggplot(aes(x = carat, y = price), data = small_diamonds)
pvc

# Here we add some points to show the scatterplot:

pvc <- ggplot(aes(x = carat, y = price), data = small_diamonds) +
  geom_point()
pvc

# Notice that the background is different. The default ggplot axes and
# backgrounds are generally preferred by visualization professionals,
# but all of these features can be changed if you like.
#
# The following two commands make the same plot:

pvc <- ggplot(aes(x = carat, y = price), data = small_diamonds) +
  geom_point(aes(color = cut))
pvc

pvc <- ggplot(aes(x = carat, y = price, color = cut), data = small_diamonds) +
  geom_point()
pvc

# Making the colored point plot with base R graphics
#
# Note that this is a bit of a hack recommended online at the Stack
# Overflow website. It is not a systematic way of doing things.

plot(small_diamonds$carat, small_diamonds$price,
     col = small_diamonds$cut, pch = 16)
legend("bottomright", legend = unique(small_diamonds$cut),
       col = 1:length(small_diamonds$cut), pch = 16)



# Part II -- Demonstrations
#
# Data for this part of the demo is the "milk_data.csv" file included
# with the workshop files. If you are running this file from the
# location where the code is located, it will know where the data is
# located. If something goes wrong, from the menu at the top of
# RStudio, select "Sesion | Set Working Directory | To Source File
# Location" this should fix things and when you re-run the file load
# command below it should work.

milk <- read.csv("milk_data.csv")  # This data is used in ref (2) above

head(milk)  # Show first few lines of the file

# Setup of the starting graph (no plot, just specifying information):

ggplot(data = milk, aes(x = time, y = protein))

# Basic Graph: protein versus time:

ggplot(data = milk, aes(x = time, y = protein)) + geom_point()

# Notice the difference here: unlike the slide examples we are not
# assigning the plot to a name. So the plots just appear. The downside
# of this is that the plots cannot be further manipulated, just shown.
# This is ok for a demo, but for real work it is not usually what you
# want to do.
#
# Add the diet as a color (a different aesthetic). There are two ways
# to do this. We can change the original specification or we can add a
# new aesthetic to the points directly:

# Change specification at the first layer:

ggplot(data = milk, aes(x = time, y = protein, col = diet)) + geom_point()

# It is important to look at your data carefully -- there is a lot
# missing here, because the points often cover each other. Do the
# diets look like they are equal in sampling?

table(milk$diet)

# We can reduce this problem with a standard technique, adding a jitter to
# the points. This works REALLY well here, because it is easy to
# see/explain to viewers that the "time" variable is always on integer
# values, so the jitter will not be too confusing.

ggplot(data = milk, aes(x = time, y = protein, col = diet)) +
        geom_point() + geom_jitter()

# This better shows the density of the various diets.
#
# Note that we can adjust the amount of jitter we think it is not clear to
# which day each observation belongs.

ggplot(data = milk, aes(x = time, y = protein, col = diet)) +
        geom_point() + geom_jitter(width = 0.25, height = 0.25)

# We can now fit a line over this:

ggplot(data = milk, aes(x = time, y = protein, col = diet)) +
  geom_point() + geom_jitter(width = 0.25, height = 0.25) +
  geom_smooth(se = FALSE, lwd = 1.5)

# Maybe we want to reserve color for just the lines. How would we do
# this?
#
# Let's think about order for a moment, here we redo the plot with the
# color removed from the points and the lines done as above (layered
# on top of the points). We will set the points to gray.

ggplot(data = milk, aes(x = time, y = protein)) +
  geom_point(color = "gray50") + geom_jitter(width = 0.25, height = 0.25) +
  geom_smooth(aes(col = diet), se = FALSE, lwd = 1.5)

# Well this is not right, why are some points gray and some black (the
# default color)? Note that we called jitter to move the points around, and
# the ones that are not jittered are all gray while the ones moved are
# black.

ggplot(data = milk, aes(x = time, y = protein)) +
  geom_point(color = "gray50") +
  geom_jitter(width = 0.25, height = 0.25, color = "gray50") +
  geom_smooth(aes(col = diet), se = FALSE, lwd = 1.5)

# Note that the order matters:

ggplot(data = milk, aes(x = time, y = protein)) +
  geom_smooth(aes(col = diet), se = FALSE, lwd = 2) + # Move the line to the 1st layer
  geom_point(color = "gray50") +
  geom_jitter(width = 0.25, height = 0.25, color = "gray50")

# Note that the dots are on top of the lines now!
#
# Another view of the data might want daily summaries (boxplots):

ggplot(data = milk, aes(x = as.factor(time), y = protein)) +
  geom_boxplot(lwd = 1.5)

# Notice the trick here: the time variable has to be set to be a
# "factor" so that R will recognize it as a "grouping variable".
#
# Here is a plot that shows the points, summaries by day (boxplots), and
# a summary line that averages over all three diets at once:

ggplot(data = milk, aes(x = as.factor(time), y = protein)) +
  geom_point(color = "gray50") +
  geom_jitter(width = 0.25, height = 0.25, color = "gray50") +
  geom_boxplot(outlier.shape = NA, alpha = 0.50, lwd = 1.5) +
  geom_smooth(aes(x = time), lwd = 2, color = "red")

# Notice the new trick: in the first three layers, x is a FACTOR time,
# as that works for points, jitter, and boxplots. Then it is changed
# to a continuous variable (a number) for the geom_smooth() function
# to fit the line. We have also eliminated the groups (diet) so we get
# one line only.
#
# Swap the boxplot for the currently more trendy "violin plot":

ggplot(data = milk, aes(x = as.factor(time), y = protein)) +
  geom_point(color = "gray50") +
  geom_jitter(width = 0.25, height = 0.25, color = "gray50") +
  geom_violin(outlier.shape = NA, alpha = 0.50, lwd = 1.5) +
  geom_smooth(aes(x = time), lwd = 2, color = "red")

# Facets
#
# Facets are used to break data into groups and make a different plot
# for each group. This is an important part of making plots make sense
# for complex arrangements of data.
#
# In this example we will use a variable for part of the plot and then
# add additional layers to it to change it.

p <- ggplot(data = milk, aes(x = time, y = protein)) + geom_point()

p # Show the plot, p

p + facet_wrap(~diet)    # Show the plot p with facets

p + facet_wrap(~diet) + geom_smooth(lwd = 1.5)    # Facets + Smoothers

# Note that the two plots where we added things to p did NOT change p
# itself:

p # The original plot!

# If we want to update p to hold the new plot, we need to do this:

p <- p + facet_wrap(~diet) + geom_smooth(lwd = 1.5) # Note: does not show

p # Show the new plot

# Another Facet Example
#
# Here we do a DENSITY plot of protein levels (kind of like histograms
# but smoothed more) by diet and faceted by time:

ggplot(milk, aes(x = protein, color = diet)) + geom_density() +
  facet_wrap(~time)

# If you prefer histgograms:

ggplot(milk, aes(x = protein, color = diet)) + geom_histogram() +
  facet_wrap(~time)

# Note that we set color and that is the color of the OUTLINE of a
# histogram. We likely meant to use fill:

ggplot(milk, aes(x = protein, color = diet)) +
  geom_histogram(aes(fill = diet)) +
  facet_wrap(~time)

# Technically this shows the same basic information as the density
# plot figure, but the histograms are harder to read and interpret
# with multiple overlays of data. The density is better in how it
# shows things and also in that it averages the data a bit. For group
# comparisons of distribution, statisticians prefer the density plots.

# EOF