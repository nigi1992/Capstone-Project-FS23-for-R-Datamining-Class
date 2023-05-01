# Spatial analysis
# Goal: To calculate distance between each spot to identify clusters

#installing and loading appropriate packages
install.packages("sf")
library(sf)
install.packages("sp")
library(sp)
library(ggplot2)

install.packages("readxl")
library(readxl)

# import excel file
df <- read_excel("halteplaetze-jenische_sinti_roma_2056.xlsx")

# pick the data with cleaned out missing values: data_clean
# convert the data to a spatial object
data_sf <- st_as_sf(data_clean, coords = c("E-Koordinate", "N-Koordinate"), crs = "+proj=utm +zone=32 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")

# plot the spatial data
ggplot(data_sf) + geom_sf() + labs(title = "Geolocations of Caravan Spots for Fahrende in Switzerland", x="Longitude", y="Latitude")

library(here)
save(ggplot, file = here("data", "ggplot1.RData")) #saving ggplot in R format
ggsave(file = here("images", "Image1.png")) #saving as image

# Conduct spatial analysis
# Count the number of locations by canton

canton_count2 <- aggregate(data_clean["Kanton"], by = list(data_clean$Kanton), length)
colnames(canton_count2) <- c("Kanton", "Anzahl_Locations")

#Bar Chart
ggplot(canton_count2, aes(x = Kanton, y = Anzahl_Locations)) +
  geom_bar(stat = "identity")

# Spots per Kanton
# have to rename because of ä and empty space
colnames(data_clean)
colnames(data_clean)[9] <- 'Anzahl_Spots'

# Ggplot geom_bar
ggplot(data_clean, aes(x = Kanton, y = Anzahl_Spots)) +
  geom_bar(stat = "identity") + ggtitle("Anzahl Spots pro Kanton")
save(ggplot, file = here("data", "ggplot2.RData")) #saving ggplot in R format
ggsave(file = here("images", "Image2.png")) #saving as image



## Underlie a map of Switzerland under the spatial data plot
install.packages("ggmap")
library(ggmap)

data_sf <- st_as_sf(data_clean, coords = c("E-Koordinate", "N-Koordinate"), crs = "+proj=utm +zone=32 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")

# Get the bounding box for Switzerland
switzerland_bbox <- c(left = 5.96, bottom = 45.82, right = 10.49, top = 47.81)

# dang it! Google now requires an API Key, will have to use an API after all
ggmap::register_google(key)
browseURL(url = "https://mapsplatform.google.com/")
API_KEY <- rstudioapi::askForPassword()
key=API_KEY
register_google(key)

# 'citation("ggmap")'!
switzerland_map <- get_map(location = switzerland_bbox, maptype = "roadmap", zoom = 7)

# Get a map of Switzerland from OpenStreetMap, use cheat sheet for ggmap
switzerland_map2 <- get_map(location=switzerland_bbox, source="stamen", maptype= "toner", crop = FALSE)
ggmap(switzerland_map2) + geom_sf()

# Plot the map and the spatial data
ggmap(switzerland_map) + geom_sf() #nope
ggmap(switzerland_map) + geom_sf(data = data_sf) #nada
ggmap(switzerland_map) + geom_sf(data = data_sf, aes(x = "E-Koordinate", y = "N-Koordinate")) #niente
# did not work out. Cant overlay the data over the map. Moving on.


