

# Setting working directory
setwd("~/GitHub/PLPA-6820")

# The x and y variables are specified inside aes(), along with additional mappings for color, shape, size, etc.
install.packages("ggplot2")
# Loading data
data <- read.csv("MycotoxinData.csv")
#### 2. Loading libraries and create a boxplot ####
library(ggplot2)
library(readr)
library(dplyr)


# using two colors
cbbPalette <- c("#0072B2", "#D55E00")  


#### 2. Change the Treatment factor order: ####
#    "NTC", "Fg", "Fg + 37", "Fg + 40", "Fg + 70"
data$Treatment <- factor(data$Treatment,
                         levels = c("NTC", "Fg", "Fg + 37", "Fg + 40", "Fg + 70"))


#### 1. Create a boxplot of DON by Treatment ####


# checking if DON is numeric
data$DON <- as.numeric(as.character(data$DON))
# filtering out zeros
data_nonzero <- subset(data, DON > 0)

plot_don <- ggplot(data_nonzero, aes(x = Treatment, y = DON, fill = Cultivar)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(aes(color = Cultivar), width = 0.2, alpha = 0.6) +
  scale_fill_manual(values = cbbPalette) +
  scale_color_manual(values = cbbPalette) +
  stat_summary(fun = mean, geom = "bar", position = "dodge") +      # Removed extra parenthesis
  stat_summary(fun.data = mean_se, geom = "errorbar", position = "dodge") +  # Removed extra '=' before mean_se
  labs(y = "DON (ppm)", x = "") +
  facet_wrap(~ Cultivar) +
  theme_classic()


# converting to log scale
plot_don +
  scale_y_log10() +
  labs(y = "DON (ppm, log scale)")

####3.Creating additional plots with different y-variables

# Convert X15ADON to numeric
data$X15ADON <- as.numeric(as.character(data$X15ADON))

# Filter out zeros from X15ADON
data_nonzero <- subset(data, X15ADON > 0)

# Create the plot for X15ADON (15aDON)
plot_15adon <- ggplot(data_nonzero, aes(x = Treatment, y = X15ADON, fill = Cultivar)) + geom_boxplot(outlier.shape = NA) +
  geom_jitter(aes(color = Cultivar), width = 0.2, alpha = 0.6) +
  scale_fill_manual(values = cbbPalette) +
  scale_color_manual(values = cbbPalette) +
  labs(y = "15aDON (ppm)", x = "") +
  facet_wrap(~ Cultivar) +
  theme_classic()

# Apply the log scale to the y-axis
plot_15adon +
  scale_y_log10() +
  labs(y = "15ADON (ppm, log scale)")

# Convert MassperSeed_mg to numeric (if not already)
data$MassperSeed_mg <- as.numeric(as.character(data$MassperSeed_mg))

# Filter out rows where MassperSeed_mg is zero (if needed)
data_nonzero_mass <- subset(data, MassperSeed_mg > 0)

# Create the plot for Seed Mass using the filtered data
plot_seedmass <- ggplot(data_nonzero_mass, aes(x = Treatment, y = MassperSeed_mg, fill = Cultivar)) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(aes(color = Cultivar), width = 0.2, alpha = 0.6) +
  scale_fill_manual(values = cbbPalette) +
  scale_color_manual(values = cbbPalette) +
  labs(y = "Seed Mass (mg)", x = "") +
  facet_wrap(~ Cultivar) +
  theme_classic()

# Apply a log scale to the y-axis
plot_seedmass +
  scale_y_log10() +
  labs(y = "Seed Mass (mg, log scale)")


#combined_plot
#install package
install.packages("ggpubr")
library(ggpubr)
combined_plot <- ggarrange(plot_don, plot_15adon, plot_seedmass,
                           ncol = 3, nrow = 1,
                           labels = c("A", "B", "C"),
                           common.legend = TRUE)

plot_don_pwc <- plot_don +
  geom_pwc(method = "t.test", label = "p.signif")

plot_15adon_pwc <- plot_15adon +
  geom_pwc(method = "t.test", label = "p.signif")

plot_seedmass_pwc <- plot_seedmass +
  geom_pwc(method = "t.test", label = "p.signif")

combined_plot_pwc <- ggarrange(plot_don_pwc, plot_15adon_pwc, plot_seedmass_pwc,
                               ncol = 3, nrow = 1,
                               labels = c("A", "B", "C"),
                               common.legend = TRUE)
print(combined_plot_pwc)

# GitHub Repository: https://github.com/mzb0226/PLPA-6820.git

