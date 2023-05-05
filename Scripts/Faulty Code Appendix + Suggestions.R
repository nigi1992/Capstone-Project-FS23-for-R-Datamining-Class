## Faulty Code Appendix:

## First Try
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

# suggestion to avoid crs confusion with R
data_sf2 <- st_as_sf(data_clean, coords = c("E-Koordinate", "N-Koordinate"), crs = 32632)
data_sf_wgs84b <- st_transform(data_sf, crs = 4326)

# Get the bounding box for Switzerland
switzerland_bbox <- c(left = 5.96, bottom = 45.82, right = 10.49, top = 47.81)

# dang it! Google now requires an API Key, will have to use an API after all
ggmap::register_google(key)
browseURL(url = "https://mapsplatform.google.com/")
API_KEY <- rstudioapi::askForPassword()
key=API_KEY

register_google(key)
# try with openstreetmap or stamen instead!

dev.off()# per suggestion dev off
dev.control()
dev.new() # revert those changes

# Get a map of Switzerland from OpenStreetMap, use cheat sheet for ggmap
# 'citation("ggmap")'!
switzerland_map <- get_map(location = switzerland_bbox, maptype = "roadmap", zoom = 7)
dev.control(switzerland_map)
# Turn coordinates numeric
data_clean$`E-Koordinate` <- as.numeric(data_clean$`E-Koordinate`)
data_clean$`N-Koordinate` <- as.numeric(data_clean$`N-Koordinate`)

# Plot the map and the spatial data
ggmap(switzerland_map) + geom_sf() #nope
ggmap(switzerland_map) + geom_sf(data = data_sf) #nada
ggmap(switzerland_map) + geom_sf(data = data_sf, aes(x = "E-Koordinate", y = "N-Koordinate")) #niente
# did not work out. Cant overlay the data over the map. Moving on.

ggmap(switzerland_map) +
  geom_sf(data = data_sf_wgs84b, aes(x = E-Koordinate, y = N-Koordinate))

ggmap(switzerland_map) +
  geom_sf(data = data_sf, aes(x = `E-Koordinate`, y = `N-Koordinate`))

st_crs(data_sf)
data_sf_wgs84 <- st_transform(data_sf, crs = 4326)
ggmap(switzerland_map) +
  geom_sf(data = data_sf_wgs84b)

# Conduct spatial analysis
# Count the number of locations by canton

canton_count2 <- aggregate(data_clean["Kanton"], by = list(data_clean$Kanton), length)
colnames(canton_count2) <- c("Kanton", "Anzahl_Locations")

#Bar Chart
ggplot(canton_count2, aes(x = Kanton, y = Anzahl_Locations)) +
  geom_bar(stat = "identity")


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
# wrong not yet there. need to count KantonID differently. Maybe with an aggregate function from above


## Second Try
# Underlie a map of Switzerland under the spatial data plot
install.packages("ggmap")
library(ggmap)
library(sf)
library(ggplot2)
library(readxl)

data_sf <- st_as_sf(data_clean, coords = c("Osten", "Norden"), crs = "+proj=utm +zone=32 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")

# Get the bounding box for Switzerland
switzerland_bbox <- c(left = 5.96, bottom = 45.82, right = 10.49, top = 47.81)

# dang it! Google now requires an API Key, will have to use an API after all
ggmap::register_google()
browseURL(url = "https://mapsplatform.google.com/")
API_KEY <- rstudioapi::askForPassword()
key=API_KEY
register_google(key)

# 'citation("ggmap")'!
switzerland_map <- get_map(location = switzerland_bbox, maptype = "roadmap", zoom = 7)

# Plot the map and the spatial data
ggmap(switzerland_map) + geom_sf() #nope
ggmap(switzerland_map) + geom_sf(data = data_sf) #nada
ggmap(switzerland_map) + geom_sf(data = data_clean, aes(x = "Osten", y = "Norden")) #niente
# did not work out. Cant overlay the data over the map. Moving on.
# also Google API no longer working -> using opensource "stamen" map instead


## Working with Openmap "stamen"
# Get a map of Switzerland from Stamen, use cheat sheet for ggmap
switzerland_map2 <- get_map(location= "Switzerland", zoom = 7, source="stamen", maptype= "terrain")

# suggestion for coordinates error message -> convert
data_sf2 <- st_as_sf(data_clean, coords = c("Osten", "Norden"), crs = 32632)

# convert coordinates to continous values
data_sf_wgs84b <- st_transform(data_sf2, crs = 4326)
# plot map with converted values
ggmap(switzerland_map2) + geom_sf(data = data_sf_wgs84b)
# didn't work this way


## Code Suggestions:

#Prompt: I have access to an excel file that shows the "Standplätze, Durchgangs und Transitplätze für Jenische, Sinti und Roma". The dataset includes: Canton, Commune and name of the locations, as well as the exact adress and east and north coordinates, the kind of spot (transit or permanent spot for the vans) and status of the location (permanent or temporary) and how many vans are allowed at each specific spot. How can I conduct with this a spatial analysis in R?
  
library(readxl)

mydata <- read_excel("path/to/myfile.xlsx")

head(mydata)
summary(mydata)
str(mydata)
class(mydata)

mydata <- na.omit(mydata)
mydata$age <- log(mydata$age)
mydata$status <- factor(mydata$status, levels=c("single", "married", "divorced", "widowed"))

mean(mydata$age)
sd(mydata$income)
quantile(mydata$score, probs=c(0.25, 0.50, 0.75))

hist(mydata$age)
boxplot(mydata$income)
plot(mydata$age, mydata$score, pch=16)
barplot(table(mydata$status))

# trying with ggplot again
install.packages("maps")
library(maps)
library(ggplot2)
ggplot(data_sf) + geom_sf() + geom_map(aes(map_id = switzerland), map = map_data())
