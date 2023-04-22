library(rnaturalearth)
library(sp)

# get nepal map
spdf_nepal <- ne_countries(country = "Nepal", scale = "medium")
plot(spdf_nepal)

# bbox of nepal
x1 <- spdf_nepal@bbox[1,1]
x2 <- spdf_nepal@bbox[1,2]
y1 <- spdf_nepal@bbox[2,1]
y2 <- spdf_nepal@bbox[2,2]

# create points from bbox
x <- seq(x1,x2,by=0.1)
y <- seq(y1,y2,by=0.1)
point.ls <- expand.grid(x,y,stringsAsFactors = FALSE)
point.ls <- as.list(data.frame(t(point.ls)))
point.ls <- lapply(point.ls, st_point)

# get points and polygon of nepal
pts <- st_sfc(point.ls)
pol <- st_polygon(list(spdf_nepal@polygons[[1]]@Polygons[[1]]@coords))

# find points fall in polygon
pts.i <- pts[st_intersects(pol,pts)[[1]]]

# convert to matrix
pts <- t(sapply(pts.i, c))
colnames(pts) <- c("lon", "lat")
write.csv(pts, file="nepal_points.csv", row.names = FALSE)
