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

# Underlie a map of Switzerland under this data
install.packages("ggmap")
library(ggmap)

data_sf <- st_as_sf(data_clean, coords = c("E-Koordinate", "N-Koordinate"), crs = "+proj=utm +zone=32 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")

# Get the bounding box for Switzerland
switzerland_bbox <- c(left = 5.96, bottom = 45.82, right = 10.49, top = 47.81)

# dang it! Google now requires an API Key, will have to use an API after all
ggmap::register_google()
browseURL(url = "https://mapsplatform.google.com/")
api_key <- rstudioapi::askForPassword()
register_google(api_key)

# Get a map of Switzerland from OpenStreetMap, use cheat sheet for ggmap
# 'citation("ggmap")'!
switzerland_map <- get_map(location = switzerland_bbox, maptype = "roadmap", zoom = 7)

# Plot the map and the spatial data
ggmap(switzerland_map) + geom_sf() #nope
ggmap(switzerland_map) + geom_sf(data = data_sf) #nada
ggmap(switzerland_map) + geom_sf(data = data_clean, aes(x = "E-Koordinate", y = "N-Koordinate")) #niente
# did not work out. Cant overlay the data over the map. Moving on.


# Conduct spatial analysis
# Count the number of locations by canton
canton_count <- aggregate(data_sf["Kanton"], by = list(data_sf$Kanton), length)
colnames(canton_count) <- c("Kanton", "Anzahl_Locations", "Coordinates")
view(canton_count)                          

#Bar Chart
ggplot(canton_count, aes(x = Kanton, y = Anzahl_Locations)) +
  geom_bar(stat = "identity") #nope

ggplot(canton_count$Kanton, canton_count$Anzahl_Spots, aes(x=cty, y = hwy)) + geom_bar(x=Kanton) #nöööö
# doesn't work

# Spots per Kanton
# have to rename because of ä and empty space
colnames(data_clean)
colnames(data_clean)[9] <- 'Anzahl_Spots'

# Ggplot geom_bar
ggplot(data_clean, aes(x = Kanton, y = Anzahl_Spots)) +
  geom_bar(stat = "identity") + ggtitle("Anzahl Spots pro Kanton")
save(ggplot, file = here("data", "ggplot2.RData")) #saving ggplot in R format
ggsave(file = here("images", "Image2.png")) #saving as image

colnames(data_clean)
colnames(data_clean)[2] <- 'KantonID'
ggplot(data_clean, aes(x = Kanton, y = KantonID)) +
  geom_bar(stat = "identity") + ggtitle("Anzahl Spots pro Kanton")
# wrong not yet there. need to count KantonID differently. Maybe with a aggregate function from above
