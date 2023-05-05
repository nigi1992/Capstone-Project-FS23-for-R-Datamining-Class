##Data Visualization

# Underlie a map of Switzerland under the spatial data plot
install.packages("ggmap")
library(ggmap)
library(sf)
library(ggplot2)
library(readxl)
library(here)

# Loading Switzerland basemap using ggmap
switzerland_map3 <- get_map(location = "Switzerland", zoom = 7, source = "stamen", maptype = "terrain")

# 'Osten' and 'Norden' are column names for coordinates in data set
coordinates <- data_clean[, c("Osten", "Norden")]
sf_data_clean <- st_as_sf(data_clean, coords = c("Osten", "Norden"), crs = 2056) # Assuming Swiss CH1903+ / LV95 coordinate reference system (EPSG: 2056)

# Transform the data to match the base map CRS (EPSG:4326)
sf_data_clean_transformed <- st_transform(sf_data_clean, crs = 4326)

# Plot the data
ggmap(switzerland_map3) +
  geom_sf(data = sf_data_clean_transformed, inherit.aes = FALSE) +
  theme_minimal()

# Plot the data with more detail
ggmap(switzerland_map3) +
  geom_sf(data = sf_data_clean_transformed, inherit.aes = FALSE,
          aes(color = factor(`Platz Status**`), shape = factor(`Platzart*`))) +
  scale_color_manual(values = c("1" = "red", "2" = "blue"),
                     name = "Platz Status",
                     labels = c("1" = "definitiv", "2" = "provisorisch")) +
  scale_shape_manual(values = c("1" = 16, "2" = 17, "3" = 18),
                     name = "Platzart",
                     labels = c("1" = "Standplatz", "2" = "Durchgangsplatz", "3" = "Transitplatz")) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  labs(title = "Spatial distribution of spots for Jenische, Sinti, and Roma in Switzerland",
       subtitle = "Differentiated by Platz Status and Platzart")

# save plot
save(ggplot, file = here("data", "ggplotMap.RData")) #saving ggplot in R format
ggsave(file = here("images", "Map.png")) #saving as image
