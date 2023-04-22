library(rnaturalearth)
library(sp)
library(ggplot2)

# read data
precip <- read.csv("precip.csv")[,-1]
coords <- read.csv("nepal_points.csv")

# get nepal map
nepal <- ne_countries(country = "Nepal", scale = "medium", returnclass = "sf")

# plot
t <- 1
data <- cbind(coords, t(precip[t,-1]))
colnames(data) <- c("lon", "lat", "rain")
ggplot() +
  geom_sf(data=nepal) +
  theme_light() +
  geom_point(data=data, aes(x=lon,y=lat,color=rain), 
             pch=19, size=0.5) +
  scale_color_gradient(low = "blue", high = "red") +
  ggtitle("Nepal")

# process date
precip[,1] <- as.Date(precip[,1])
precip$year <- strftime(precip[,1], "%Y")
precip$month <- strftime(precip[,1], "%m")
precip$day <- strftime(precip[,1], "%d")

# average precipitation by month
for (m in 1:12) {
  # find mean precip
  month <- sprintf("%02d", m)
  p <- precip[precip$month == month, paste0("X", 1:1347)]
  mean.p <- colMeans(p, na.rm = TRUE)
  
  # plot
  data <- cbind(coords, mean.p)
  colnames(data) <- c("lon", "lat", "rain")
  print(ggplot() +
  geom_sf(data=nepal) +
  theme_light() +
  geom_point(data=data, aes(x=lon,y=lat,color=rain), 
             pch=19, size=0.5) +
  scale_color_gradient(name="precip(mm/day)", low="blue", high="red", guide="colorbar", limits=c(0,25)) +
  ggtitle(paste("Nepal Month:", month.abb[as.numeric(month)])))
  
  # save
  ggsave(paste0("plots/", m, "_", month.abb[as.numeric(month)], ".png"))
}


# total precipitation by year
for (y in 2013:2022) {
  # find mean precip
  year <- toString(y)
  p <- precip[precip$year == year, paste0("X", 1:1347)]
  total.p <- colSums(p, na.rm = TRUE)
  print(range(total.p))
  
  # plot
  data <- cbind(coords, total.p)
  colnames(data) <- c("lon", "lat", "rain")
  print(ggplot() +
          geom_sf(data=nepal) +
          theme_light() +
          geom_point(data=data, aes(x=lon,y=lat,color=rain), 
                     pch=19, size=0.5) +
          scale_color_gradient(name="precip(mm/year)", low="blue", high="red", guide="colorbar", limits=c(300,3900)) +
          ggtitle(paste("Nepal Year:", year)))
  
  # save
  ggsave(paste0("plots/", year, ".png"))
}



