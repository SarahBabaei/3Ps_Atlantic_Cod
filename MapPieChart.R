#Load Map_byfishery_pi.txt using import dataset in R studio
#load and install libraries
install.packages("reshape")
install.packages("rworldmap")
install.packages("rworldxtra")

library(reshape)
library(rworldmap)
library(rworldxtra)

#need to convert lats and longs
llconvert <- function(x) {
  ifelse(as.numeric(substring(x, 1, 2)) != 0, as.numeric(substring(x, 1, 2)) + 
           (as.numeric(substring(x, 3, 4)) + as.numeric(substring(x, 5, 5))/10)/60, NA)
}

Map_byfishery_pi$Lat_Start2 <- llconvert(Map_byfishery_pi$AverageLat)
Map_byfishery_pi$Lon_Start2 <- llconvert(Map_byfishery_pi$AverageLon)
Map_byfishery_pi$Lon_Start2 <- -Map_byfishery_pi$Lon_Start2

#mapping
Canada <- getMap()

names(Map_byfishery_pi[3])

mapPies(Map_byfishery_pi, nameX = "Lon_Start2", nameY = "Lat_Start2", nameZs = c('POP2', 'POP1', 'POP3'),
        zColours = c("black", "darkgray", "white"),oceanCol = "lightblue", landCol = "lightgray", 
        xlim = c(-74, -50), ylim = c(40, 55), symbolSize = 1.5)

#put latlon axes on
axis(1)
axis(2)
