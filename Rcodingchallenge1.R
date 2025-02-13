setwd("C:/Users/muhta/OneDrive/Desktop/ENTM-6820")  # Set working directory
getwd()  # Verify working directory

#Creating a vector named 'z' with values from 1 to 200
z <- 1:200

#Print mean and standard deviation of z
print(mean(z))
print(sd(z))

#Creating a logical vector zlog: TRUE for values greater than 30, FALSE otherwise
logz <- z > 30

#Creating a dataframe zdf with z and zlog as columns
zdf <- data.frame(z, logz)

#Renaming columns to 'zvec' and 'zlogic'
names(zdf) <- c("zvec", "zlogic")

#Adding a new column zsquared equal to zvec squared
zdf$zsquared <- zdf$zvec^2

#Subsetting dataframe where zsquared is greater than 10 and less than 100 (two methods)
zdf_subset1 <- subset(zdf, zsquared > 10 & zsquared < 100)
zdf_subset2 <- zdf[zdf$zsquared > 10 & zdf$zsquared < 100, ]

#Subsetting the dataframe to include only row 26
zdf_row26 <- zdf[26, ]

# Subset the zsquared column for the 180th row
zsquared_180 <- zdf$zsquared[180]
