
view(MycotoxinData.csv)
# Setting working directory
setwd("C:/Users/muhta/OneDrive/Desktop/ENTM-6820") 
# Loading data
data <- read.csv("MycotoxinData.csv")
# The x and y variables are specified inside aes(), along with additional mappings for color, shape, size, etc.
install.packages("ggplot2")

#### 2. Loading libraries and create a boxplot ####
library(ggplot2)
library(readr)
library(dplyr)
# Boxplot
ggplot(data, aes(x = Treatment, y = DON, color = Cultivar)) +
  geom_boxplot() +
  labs(y = "DON (ppm)", x = "") +
  theme_minimal()


# 3. Creating Bar chart with standard-error error bars
ggplot(data, aes(x = Treatment, y = DON, fill = Cultivar)) +
  stat_summary(fun = mean, geom = "bar", position = position_dodge(), width = 0.6) +
  stat_summary(fun.data = mean_se, geom = "errorbar", position = position_dodge(0.6), width = 0.2) +
  labs(y = "DON (ppm)", x = "") +
  theme_minimal()


# 4. Adding points over boxplot and bar chart
ggplot(data, aes(x = Treatment, y = DON, fill = Cultivar)) +
  geom_boxplot() +
  geom_jitter(shape = 21, position = position_jitterdodge(jitter.width = 0.2), color = "black") +
  labs(y = "DON (ppm)", x = "") +
  theme_minimal()



# 5.Applying colorblind-friendly palette
cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

ggplot(data, aes(x = Treatment, y = DON, fill = Cultivar)) +
  geom_boxplot() +
  scale_fill_manual(values = cbbPalette) +
  labs(y = "DON (ppm)", x = "") +
  theme_minimal()


# 6. Faceting the plots based on cultivar
ggplot(data, aes(x = treatment, y = DON, fill = cultivar)) +
  geom_boxplot() +
  facet_wrap(~cultivar) +
  labs(y = "DON (ppm)", x = "") +
  theme_minimal()


# 7. Adding transparency to points
ggplot(data, aes(x = Treatment, y = DON, fill = Cultivar)) +
  geom_boxplot() +
  geom_jitter(shape = 21, position = position_jitterdodge(jitter.width = 0.2), 
              alpha = 0.5, color = "grey") +
  labs(y = "DON (ppm)", x = "") +
  theme_minimal()



# 8. Exploring another visualization (violin plot)
ggplot(data, aes(x = Treatment, y = DON, fill = Cultivar)) +
  geom_violin() +
  geom_jitter(shape = 21, position = position_jitterdodge(jitter.width = 0.2), 
              color = "pink") +
  labs(y = "DON (ppm)", x = "") +
  theme_minimal()


# I would choose the violin plot because it better represents the distribution of data while still allowing individual points to be visualized.


# 9. Push code to GitHub and fork repository
#I still don't couldn't find a partner as I had to miss class due to my illness, I would update it when I find someone.
# GitHub repository URLs:
#https://github.com/mzb0226/PLPA-6820.git
