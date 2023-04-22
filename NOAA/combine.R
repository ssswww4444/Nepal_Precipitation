n.points <- 1347

# read data
rain = list()
for(i in 1:n.points){
  loc = i
  rain[[i]] = read.csv(paste0("data_points/", i,".csv"), header = TRUE)
}

# combine all
data <- rain[[1]][-1,1]
for (i in 1:n.points) {
  data <- cbind(data,rain[[i]][-1,4])
}
data <- as.data.frame(data)
colnames(data) <- c("time", 1:n.points)

# save
write.csv(data,"precip.csv")
