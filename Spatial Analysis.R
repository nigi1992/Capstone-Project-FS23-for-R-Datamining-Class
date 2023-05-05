### Spatial analysis
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

#Renaming Columns to avoid Encoding errors
colnames(data_clean)
colnames(data_clean)[10] <- 'Osten'
colnames(data_clean)[11] <- 'Norden'

# pick the data with cleaned out missing values: data_clean
# convert the data to a spatial object
data_sf <- st_as_sf(data_clean, coords = c("Osten", "Norden"), crs = "+proj=utm +zone=32 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")

# plot the spatial data
ggplot(data_sf) + geom_sf() + labs(title = "Geolocations of Caravan Spots for Fahrende in Switzerland", x="Longitude", y="Latitude")

library(here)
save(ggplot, file = here("data", "ggplot1.RData")) #saving ggplot in R format
ggsave(file = here("images", "Image1.png")) #saving as image

## Conduct spatial analysis
## Count the number of locations by canton

canton_count <- aggregate(data_clean["Kanton"], by = list(data_clean$Kanton), length)
colnames(canton_count) <- c("Kanton", "Anzahl_Locations")

#Bar Chart
ggplot(canton_count, aes(x = Kanton, y = Anzahl_Locations)) +
  geom_bar(stat = "identity")
save(ggplot, file = here("data", "ggplot2.RData")) #saving ggplot in R format
ggsave(file = here("images", "Image2.png")) #saving as image


## Spots per Kanton
# have to rename because of ä and empty space -> Encoding Errors
colnames(data_clean)
colnames(data_clean)[9] <- 'Anzahl_Spots'

# Ggplot geom_bar
ggplot(data_clean, aes(x = Kanton, y = Anzahl_Spots)) +
  geom_bar(stat = "identity") + ggtitle("Anzahl Spots pro Kanton")
save(ggplot, file = here("data", "ggplot3.RData")) #saving ggplot in R format
ggsave(file = here("images", "Image3.png")) #saving as image


# Next: more spatial analysis and descriptive statistics

# 'Osten' and 'Norden' are column names for coordinates in data set
coordinates <- data_clean[, c("Osten", "Norden")]
sf_data_clean <- st_as_sf(data_clean, coords = c("Osten", "Norden"), crs = 2056) # Assuming Swiss CH1903+ / LV95 coordinate reference system (EPSG: 2056)

# Calculating distance matrix between all locations
distance_matrix <- st_distance(sf_data_clean)

# Converting the distance matrix to a data frame and round the values, convert to km instead of m
distance_matrix_df <- round(as.data.frame(distance_matrix / 1000), 2)

# Include the unit (km) in the cell values
distance_matrix_df_with_unit <- data.frame(lapply(distance_matrix_df, function(x) paste0(x, " km")))

# Set row and column names to "Standort" values
rownames(distance_matrix_df_with_unit) <- sf_data_clean$Standort
colnames(distance_matrix_df_with_unit) <- sf_data_clean$Standort

# Display the distance matrix as a table
print(distance_matrix_df_with_unit)











