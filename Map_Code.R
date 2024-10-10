# Load useful packages
library(sf)
library(marmap)
library(tidyverse)
library(rnaturalearth)

#load latlon information. please note that the reference population file is already converted for ALL POPULATIONS.
scales <- read.csv("latlon_onlygregs.csv", header = TRUE)

#Function for converting the original 3Ps latlon data (latlon_3Ps.csv) into plottable latlon data found in the reference population file.
llconvert <- function(x) {
  ifelse(as.numeric(substring(x, 1, 2)) != 0, as.numeric(substring(x, 1, 2)) + 
           (as.numeric(substring(x, 3, 4)) + as.numeric(substring(x, 5, 5))/10)/60, NA)
}
scales$Lat_Start2 <- llconvert(scales$lat)
scales$Lon_Start2 <- llconvert(scales$lon)
scales$Lon_Start2 <- -scales$Lon_Start2

# Get bathymetric data
bat <- getNOAA.bathy(lon1 = -75, lon2 = -50, lat1 = 30, lat2 = 60, keep = TRUE)
bat_xyz <- as.xyz(bat)

#get map of Canada
canada_map <- ne_states(country = "canada", returnclass = "sf")


# Plot using ggplot and sf
ggplot() + 
  geom_sf(data = canada_map) +
  geom_tile(data = bat_xyz, aes(x = V1, y = V2, fill = V3)) +
  geom_contour(data = bat_xyz, 
               aes(x = V1, y = V2, z = V3),
               binwidth = 100, color = "grey85", size = 0.1) +
  geom_contour(data = bat_xyz, 
               aes(x = V1, y = V2, z = V3),
               breaks = -200, color = "grey85", size = 0.5) +
  geom_sf(data = canada_map) +
  coord_sf(xlim = c(-74, -50), ylim = c(40, 55)) +
  geom_point(data=scales, aes(x=scales$LONDEC, y=scales$LATDEC), colour="black", 
             fill="red", pch=21, size=1.0, alpha=I(0.7))+
  labs(x = "Longitude", y = "Latitude", fill = "Depth (m)") +
  theme_minimal()
