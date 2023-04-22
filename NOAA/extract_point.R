# https://coastwatch.pfeg.noaa.gov/erddap/griddap/documentation.html
# https://coastwatch.pfeg.noaa.gov/erddap/griddap/chirps20GlobalDailyP05.html

library(parallel)

points <- read.csv("../nepal_points.csv")
cl <<- makeCluster(detectCores() - 1)

counts <- clusterApply(cl, 126:dim(points)[1], function(i) {
  t1 <- "2013-01-01"
  t2 <- "2023-03-01"
  name <- i
  lat1 <- points[i,2]
  lat2 <- points[i,2]
  lon1 <- points[i,1]
  lon2 <- points[i,1]
  url <- paste0("https://coastwatch.pfeg.noaa.gov/erddap/griddap/chirps20GlobalDailyP05.csv?precip%5B(",
                t1, "T00:00:00Z):1:(", t2, "T00:00:00Z)%5D%5B(",
                lat1, "):1:(", lat2, ")%5D%5B(", lon1, "):1:(", lon2, ")%5D")
  download.file(url=url, destfile=sprintf("data_points/%s.csv", name))
})

# # check missing ones
# pt <- c()
# for(i in 1:1347) {
#   if (!file.exists(paste0("~/Projects/Nepal_Precipitation/NOAA/data_points/",i,".csv"))) {
#     pt <- c(pt, i)
#   }
# }