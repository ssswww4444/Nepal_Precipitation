rain = list()
for(i in 1:1347){
  loc = i
  rain[[i]] = read.csv(paste0("NOAA/data_points/", i,".csv"), header = TRUE)
}

# combine all
data <- rain[[1]][-1,1]
for (i in 1:1347) {
  data <- cbind(data,rain[[i]][-1,4])
}
data <- as.data.frame(data)
colnames(data) <- c("time", 1:1347)
write.csv(data,"precip.csv")


# upload to: smb://uom-file3.unimelb.edu.au/6200/Shares/Max/Restricted/workspace (Finder -> Go -> connect to server)

