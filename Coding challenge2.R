#### 1. Explanation of ggplot concepts####
# a. The three essential elements of ggplot:
#    1. Data: The dataset used to create the plot.
#    2. Aesthetics (aes): Mapping of variables to visual properties.
#    3. Geometric objects (geoms): The actual graphical representation of data.

# b. A geom (geometric object) determines the type of plot we create, such as geom_point() for scatter plots or geom_boxplot() for box plots.

# c. A facet is used to create multiple panels (small multiples) of plots based on a categorical variable using facet_wrap() or facet_grid().

# d. Layering in ggplot allows adding multiple graphical elements, such as points over a boxplot or error bars on a bar chart.

# e. The x and y variables are specified inside aes(), along with additional mappings for color, shape, size, etc.
install.packages("ggplot2")

#### 2. Loading libraries and create a boxplot ####
library(ggplot2)
library(readr)
library(dplyr)

