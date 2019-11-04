# Tanay Mukherjee
# 28 Oct. 2019

# Libraries
library(tidyverse)
library(cluster)
library(factoextra)
library(gridExtra)
library(ggplot2)
library(dplyr)

# Load Data
data('USArrests') 
? USArrests

d_frame <- USArrests
d_frame <- na.omit(d_frame)  #Removing the missing values
d_frame <- scale(d_frame)
head(d_frame)

# Calculate the Euclidean Distance
distance <- get_dist(d_frame)
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

# Check for K=2
kmeans2 <- kmeans(d_frame, centers = 2, nstart = 25)
str(kmeans2)

fviz_cluster(kmeans2, data = d_frame)

# Cluster by text
d_frame %>% as_tibble() %>% mutate(cluster = kmeans2$cluster,
         state = row.names(USArrests)) %>%
  ggplot(aes(UrbanPop, Murder, color = factor(cluster), label = state)) + geom_text()



# Checking for optimal soulution in K-means
# 1.
# Elbow method
# Ref: https://afit-r.github.io/kmeans_clustering
df <- d_frame

set.seed(123)

# function to compute total within-cluster sum of square 
wss <- function(k) {
  kmeans(df, k, nstart = 10 )$tot.withinss
}

# Compute and plot wss for k = 1 to k = 15
k.values <- 1:15

# extract wss for 2-15 clusters
wss_values <- map_dbl(k.values, wss)

plot(k.values, wss_values,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Total within-clusters sum of squares")

set.seed(123)
fviz_nbclust(df, kmeans, method = "wss")


# 2.
# function to compute average silhouette for k clusters
avg_sil <- function(k) {
  km.res <- kmeans(df, centers = k, nstart = 25)
  ss <- silhouette(km.res$cluster, dist(df))
  mean(ss[, 3])
}

# Compute and plot wss for k = 2 to k = 15
k.values <- 2:15

# extract avg silhouette for 2-15 clusters
avg_sil_values <- map_dbl(k.values, avg_sil)

plot(k.values, avg_sil_values,
     type = "b", pch = 19, frame = FALSE, 
     xlab = "Number of clusters K",
     ylab = "Average Silhouettes")
fviz_nbclust(df, kmeans, method = "silhouette")


# 3.
# Gap Statistic Method
# compute gap statistic

set.seed(123)
gap_stat <- clusGap(df, FUN = kmeans, nstart = 25,
                    K.max = 10, B = 50)
# Print the result
print(gap_stat, method = "firstmax")
fviz_gap_stat(gap_stat)


# Final Clustering
# --
kmeans3 <- kmeans(d_frame, centers = 3, nstart = 25)  #DataFlair
kmeans4 <- kmeans(d_frame, centers = 4, nstart = 25)  
kmeans5 <- kmeans(d_frame, centers = 5, nstart = 25)  

#Comparing the Plots
  plot1 <- fviz_cluster(kmeans2, geom = "point", data = d_frame) + ggtitle("k = 2")
  plot2 <- fviz_cluster(kmeans3, geom = "point", data = d_frame) + ggtitle("k = 3")
  plot3 <- fviz_cluster(kmeans4, geom = "point", data = d_frame) + ggtitle("k = 4")
  plot4 <- fviz_cluster(kmeans5, geom = "point", data = d_frame) + ggtitle("k = 5")
  grid.arrange(plot1, plot2, plot3, plot4, nrow = 2)
# --
  
