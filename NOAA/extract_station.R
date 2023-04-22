# https://coastwatch.pfeg.noaa.gov/erddap/griddap/documentation.html
# https://coastwatch.pfeg.noaa.gov/erddap/griddap/chirps20GlobalDailyP05.html

stations <- read.csv("../stations.csv")

for (i in 1:dim(stations)[1]) {
  t1 <- "2013-01-01"
  t2 <- "2023-03-01"
  name <- stations[i,1]
  lat1 <- stations[i,2]
  lat2 <- stations[i,2]
  lon1 <- stations[i,3]
  lon2 <- stations[i,3]
  url <- paste0("https://coastwatch.pfeg.noaa.gov/erddap/griddap/chirps20GlobalDailyP05.csv?precip%5B(",
                t1, "T00:00:00Z):1:(", t2, "T00:00:00Z)%5D%5B(",
                lat1, "):1:(", lat2, ")%5D%5B(", lon1, "):1:(", lon2, ")%5D")
  download.file(url=url, destfile=sprintf("data_station/%s.csv", name))
}
