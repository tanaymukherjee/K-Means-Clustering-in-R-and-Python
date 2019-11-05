# Tanay Mukherjee
# 28 Oct. 2019
# Horizontal Clustering
# Agglomerative Clustering

# Libraries
library(tidyverse)
library(cluster)
library(factoextra)
library(gridExtra)
library(ggplot2)
library(dplyr)

# Load the data
data("USArrests")

# Standardize the data
df <- scale(USArrests)

# Show the first 6 rows
head(df, nrow = 6)

# Compute the dissimilarity matrix
# df = the standardized data
res.dist <- dist(df, method = "euclidean")

as.matrix(res.dist)[1:6, 1:6]

res.hc <- hclust(d = res.dist, method = "ward.D2")

#Cluster Dendogram
# cex: label size
fviz_dend(res.hc, cex = 0.5)

# Compute cophentic distance
res.coph <- cophenetic(res.hc)
# Correlation between cophenetic distance and
# the original distance
cor(res.dist, res.coph)

res.hc2 <- hclust(res.dist, method = "average")
cor(res.dist, cophenetic(res.hc2))


# Cut tree into 4 groups
grp <- cutree(res.hc, k = 4)
head(grp, n = 4)

# Number of members in each cluster
table(grp)

# Get the names for the members of cluster 1
rownames(df)[grp == 1]


# Cut in 4 groups and color by groups
fviz_dend(res.hc, k = 4, # Cut in four groups
          cex = 0.5, # label size
          k_colors = c("#2E9FDF", "#00AFBB", "#E7B800", "#FC4E07"),
          color_labels_by_k = TRUE, # color labels by groups
          rect = TRUE # Add rectangle around groups
)

fviz_cluster(list(data = df, cluster = grp),
             palette = c("#2E9FDF", "#00AFBB", "#E7B800", "#FC4E07"),
             ellipse.type = "convex", # Concentration ellipse
             repel = TRUE, # Avoid label overplotting (slow)
             show.clust.cent = FALSE, ggtheme = theme_minimal())


# Agglomerative Nesting (Hierarchical Clustering)
res.agnes <- agnes(x = USArrests, # data matrix
                   stand = TRUE, # Standardize the data
                   metric = "euclidean", # metric for distance matrix
                   method = "ward" # Linkage method
)
# DIvisive ANAlysis Clustering
res.diana <- diana(x = USArrests, # data matrix
                   stand = TRUE, # standardize the data
                   metric = "euclidean" # metric for distance matrix
)

fviz_dend(res.agnes, cex = 0.6, k = 4)


# ----
# Comparing Dendograms

df <- scale(USArrests)

# Subset containing 10 rows
set.seed(123)
ss <- sample(1:50, 10)
df <- df[ss,]

library(dendextend)
# Compute distance matrix
res.dist <- dist(df, method = "euclidean")
# Compute 2 hierarchical clusterings
hc1 <- hclust(res.dist, method = "average")
hc2 <- hclust(res.dist, method = "ward.D2")
# Create two dendrograms
dend1 <- as.dendrogram (hc1)
dend2 <- as.dendrogram (hc2)
# Create a list to hold dendrograms
dend_list <- dendlist(dend1, dend2)


# Tanglegram
tanglegram(dend1, dend2)

tanglegram(dend1, dend2,
           highlight_distinct_edges = FALSE, # Turn-off dashed lines
           common_subtrees_color_lines = FALSE, # Turn-off line colors
           common_subtrees_color_branches = TRUE, # Color common branches
           main = paste("entanglement =", round(entanglement(dend_list), 2))
)


# Correlation matrix between a list of dendrograms

# Cophenetic correlation matrix
cor.dendlist(dend_list, method = "cophenetic")

# Baker correlation matrix
cor.dendlist(dend_list, method = "baker")

# Cophenetic correlation coefficient
cor_cophenetic(dend1, dend2)

# Baker correlation coefficient
cor_bakers_gamma(dend1, dend2)


# Create multiple dendrograms by chaining
dend1 <- df %>% dist %>% hclust("complete") %>% as.dendrogram
dend2 <- df %>% dist %>% hclust("single") %>% as.dendrogram
dend3 <- df %>% dist %>% hclust("average") %>% as.dendrogram
dend4 <- df %>% dist %>% hclust("centroid") %>% as.dendrogram
# Compute correlation matrix
dend_list <- dendlist("Complete" = dend1, "Single" = dend2,
                      "Average" = dend3, "Centroid" = dend4)
cors <- cor.dendlist(dend_list)
# Print correlation matrix
round(cors, 2)

# Visualize the correlation matrix using corrplot package
library(corrplot)
corrplot(cors, "pie", "lower")



# -----
# Visualizing Dendrograms

# Load data
data(USArrests)
# Compute distances and hierarchical clustering
dd <- dist(scale(USArrests), method = "euclidean")
hc <- hclust(dd, method = "ward.D2")

fviz_dend(hc, cex = 0.5)

fviz_dend(hc, cex = 0.5,
          main = "Dendrogram - ward.D2",
          xlab = "Objects", ylab = "Distance", sub = "")

fviz_dend(hc, cex = 0.5, horiz = TRUE)

fviz_dend(hc, k = 4, # Cut in four groups
          cex = 0.5, # label size
          k_colors = c("#2E9FDF", "#00AFBB", "#E7B800", "#FC4E07"),
          color_labels_by_k = TRUE, # color labels by groups
          rect = TRUE, # Add rectangle around groups
          rect_border = c("#2E9FDF", "#00AFBB", "#E7B800", "#FC4E07"),
          rect_fill = TRUE)


fviz_dend(hc, k = 4, # Cut in four groups
          cex = 0.5, # label size
          k_colors = c("#2E9FDF", "#00AFBB", "#E7B800", "#FC4E07"),
          color_labels_by_k = TRUE, # color labels by groups
          ggtheme = theme_gray() # Change theme
)


fviz_dend(hc, cex = 0.5, k = 4, # Cut in four groups
          k_colors = "jco")


fviz_dend(hc, k = 4, cex = 0.4, horiz = TRUE, k_colors = "jco",
          rect = TRUE, rect_border = "jco", rect_fill = TRUE)

# Circular Dendogram

fviz_dend(hc, cex = 0.5, k = 4,
          k_colors = "jco", type = "circular")


library(igraph)
fviz_dend(hc, k = 4, k_colors = "jco",
          type = "phylogenic", repel = TRUE)

fviz_dend(hc, k = 4, # Cut in four groups
          k_colors = "jco",
          type = "phylogenic", repel = TRUE,
          phylo_layout = "layout.gem")


# Zooming in the dendrogram

fviz_dend(hc, xlim = c(1, 20), ylim = c(1, 8))

# Create a plot of the whole dendrogram,
# and extract the dendrogram data
dend_plot <- fviz_dend(hc, k = 4, # Cut in four groups
                       cex = 0.5, # label size
                       k_colors = "jco"
)
dend_data <- attr(dend_plot, "dendrogram") # Extract dendrogram data
# Cut the dendrogram at height h = 10
dend_cuts <- cut(dend_data, h = 10)
# Visualize the truncated version containing
# two branches
fviz_dend(dend_cuts$upper)

# Plot the whole dendrogram
print(dend_plot)

# Plot subtree 1
fviz_dend(dend_cuts$lower[[1]], main = "Subtree 1")
# Plot subtree 2
fviz_dend(dend_cuts$lower[[2]], main = "Subtree 2")

fviz_dend(dend_cuts$lower[[2]], type = "circular")

# Sabing in PDF
pdf("dendrogram.pdf", width=30, height=15) # Open a PDF
p <- fviz_dend(hc, k = 4, cex = 1, k_colors = "jco" ) # Do plotting
print(p)
dev.off() # Close the PDF


# Manipulating dendrograms using dendextend
data <- scale(USArrests)
dist.res <- dist(data)
hc <- hclust(dist.res, method = "ward.D2")
dend <- as.dendrogram(hc)
plot(dend)

dend <- USArrests[1:5,] %>% # data
  scale %>% # Scale the data
  dist %>% # calculate a distance matrix,
  hclust(method = "ward.D2") %>% # Hierarchical clustering
  as.dendrogram # Turn the object into a dendrogram.
plot(dend)


# 1. Create a customized dendrogram
mycols <- c("#2E9FDF", "#00AFBB", "#E7B800", "#FC4E07")
dend <- as.dendrogram(hc) %>%
  set("branches_lwd", 1) %>% # Branches line width
  set("branches_k_color", mycols, k = 4) %>% # Color branches by groups
  set("labels_colors", mycols, k = 4) %>% # Color labels by groups
  set("labels_cex", 0.5) # Change label size
# 2. Create plot
fviz_dend(dend)
