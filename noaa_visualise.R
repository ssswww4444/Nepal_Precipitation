library(rnaturalearth)
library(sp)
library(ggplot2)

# read data
precip <- read.csv("precip.csv")[,-1]
coords <- read.csv("nepal_points.csv")

# get nepal map
nepal <- ne_countries(country = "Nepal", scale = "medium", returnclass = "sf")

# plot
data <- cbind(coords, t(precip[1,-1]))
colnames(data) <- c("lon", "lat", "rain")
ggplot() +
  geom_sf(data=nepal) +
  theme_light() +
  geom_point(data=data, aes(x=lon,y=lat,color=rain), pch=19, size=0.5) +
  scale_color_gradient(low = "blue", high = "red") +
  ggtitle("Nepal")

# get annual average

