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

# Select the columns containing the ratings
ratings <- d.film.imputed.1[, 4:11]

# Perform PCA
pca_result <- prcomp(ratings, scale. = TRUE)

# View summary of PCA results
summary(pca_result)

# View the PCA loadings
pca_result$rotation

# View the PCA scores
pca_scores <- pca_result$x

d.film.imputed.1_with_pca <- cbind(d.film.imputed.1, as.data.frame(pca_scores))

#Clustering

# Select the first 4 principal components
pca_scores_4 <- pca_scores[, 1:4]

# Set the number of clusters
k <- 5  # You can choose the number of clusters based on your analysis

# Perform k-means clustering
set.seed(123)  # For reproducibility
kmeans_result <- kmeans(pca_scores_4, centers = k, nstart = 25)

# View the clustering results
kmeans_result$cluster

d.film.imputed.1_with_pca$cluster <- kmeans_result$cluster

# Set the path to save the .csv file
output_file_path <- "/home/dave/work/PCA_FILM/PCA_FILM_RESULTS.csv"

# Export the data frame to a .csv file
write.csv(d.film.imputed.1_with_pca, file = output_file_path, row.names = FALSE)
