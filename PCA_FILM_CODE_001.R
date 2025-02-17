#Clear memory
rm(list=ls())

#Load packages
library(mice)
library(tidyverse)

# Set the path to your .csv file
file_path <- "/home/dave/work/PCA_FILM/PCA_FILM_DATA.csv"

# Load the dataset
d.film_input <- read.csv(file_path, header = TRUE, sep = ",")
d.film_cleaned <- d.film_input %>%
  slice(-c(160:175))

# Perform multiple imputation
d.film.mice <- mice(d.film_cleaned, m = 5, method = 'pmm', maxit = 50, seed = 500)

# Obtain first completed dataset
d.film.imputed.1 <- complete(d.film.mice, 1)
