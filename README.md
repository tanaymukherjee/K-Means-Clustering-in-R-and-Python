# K-Means-Clustering-in-R

Let’s say you want to classify hundreds (or thousands) of documents based on their content and topics, or you wish to group together different images for some reason. Or what’s even more, let’s think you have that same data already classified but you want to challenge that labeling. You want to know if that data categorization makes sense or not, or can be improved.

Well, my advice is that you cluster your data. Information is often darkened by noise and redundancy, and grouping data into clusters (clustering) with similar features is an efficient way to bring some light on.

Clustering is a technique widely used to find groups of observations (called clusters) that share similar characteristics. This process is not driven by a specific purpose, which means you don’t have to specifically tell your algorithm how to group those observations since it does it on its own (groups are formed organically). The result is that observations (or data points) in the same group are more similar between them than other observations in another group. The goal is to obtain data points in the same group as similar as possible, and data points in different groups as dissimilar as possible.

Extremely well fitted for exploratory analysis, K-means is perfect for getting to know your data and providing insights on almost all datatypes. Whether it is an image, a figure or a piece of text, K-means is so flexible it can take almost everything.

One of the rockstars in unsupervised learning
Clustering (including K-means clustering) is an unsupervised learning technique used for data classification.

Unsupervised learning means there is no output variable to guide the learning process (no this or that, no right or wrong) and data is explored by algorithms to find patterns. We only observe the features but have no established measurements of the outcomes since we want to find them out.

As opposed to supervised learning where your existing data is already labeled and you know which behaviour you want to determine in the new data you obtain, unsupervised learning techniques don’t use labelled data and the algorithms are left to themselves to discover structures in the data.

Within the universe of clustering techniques, K-means is probably one of the mostly known and frequently used. K-means uses an iterative refinement method to produce its final clustering based on the number of clusters defined by the user (represented by the variable K) and the dataset. For example, if you set K equal to 3 then your dataset will be grouped in 3 clusters, if you set K equal to 4 you will group the data in 4 clusters, and so on.

K-means starts off with arbitrarily chosen data points as proposed means of the data groups, and iteratively recalculates new means in order to converge to a final clustering of the data points.

But how does the algorithm decide how to group the data if you are just providing a value (K)? When you define the value of K you are actually telling the algorithm how many means or centroids you want (if you set K=3 you create 3 means or centroids, which accounts for 3 clusters). A centroid is a data point that represents the center of the cluster (the mean), and it might not necessarily be a member of the dataset.

This is how the algorithm works:

K centroids are created randomly (based on the predefined value of K)
K-means allocates every data point in the dataset to the nearest centroid (minimizing Euclidean distances between them), meaning that a data point is considered to be in a particular cluster if it is closer to that cluster’s centroid than any other centroid
Then K-means recalculates the centroids by taking the mean of all data points assigned to that centroid’s cluster, hence reducing the total intra-cluster variance in relation to the previous step. The “means” in the K-means refers to averaging the data and finding the new centroid
The algorithm iterates between steps 2 and 3 until some criteria is met (e.g. the sum of distances between the data points and their corresponding centroid is minimized, a maximum number of iterations is reached, no changes in centroids value or no data points change clusters)

The initial result of running this algorithm may not be the best possible outcome and rerunning it with different randomized starting centroids might provide a better performance (different initial objects may produce different clustering results). For this reason, it’s a common practice to run the algorithm multiple times with different starting points and evaluate different initiation methods (e.g. Forgy or Kaufman approaches).

But another question arises: how do you know the correct value of K, or how many centroids to create? There is no universal answer for this, and although the optimal number of centroids or clusters is not known a priori, different approaches exist to try to estimate it. One commonly used approach is testing different numbers of clusters and measure the resulting sum of squared errors, choosing the K value at which an increase will cause a very small decrease in the error sum, while a decrease will sharply increase the error sum. This point that defines the optimal number of clusters is known as the “elbow point”, and can be used as a visual measure to find the best pick for the value of K.

Source:
1. https://www.kdnuggets.com/2019/05/guide-k-means-clustering-algorithm.html
2. https://stanford.edu/~cpiech/cs221/handouts/kmeans.html by Andrew Ng
3. https://en.wikipedia.org/wiki/Euclidean_distance
4. https://www.analyticsvidhya.com/blog/2019/08/comprehensive-guide-k-means-clustering/
5. https://data-flair.training/blogs/clustering-in-r-tutorial/
