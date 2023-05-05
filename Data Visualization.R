###Data Visualization

## Underlie a map of Switzerland under the spatial data plot
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

# saving plot
save(ggplot, file = here("data", "ggplotMap.RData")) #saving ggplot in R format
ggsave(file = here("images", "Map.png")) #saving as image


## Scatter plot showing relationship between number of vans at each spot and its location in CH
# creating a scatter plot of the locations with the number of vans at each spot
ggplot() +
  geom_sf(data = sf_data_clean_transformed, 
          aes(size = Anzahl_Spots), show.legend = "point") +
  scale_size_continuous(name = "Anzahl Spots") +
  theme_minimal() +
  labs(title = "Number of Vans at Spots for Jenische, Sinti, and Roma in Switzerland",
       subtitle = "Size of the points represents the number of vans")

# Underlying this plot with map
ggmap(switzerland_map3) +
  geom_sf(data = sf_data_clean_transformed, inherit.aes = FALSE,
          aes(color = factor(`Platz Status**`), shape = factor(`Platzart*`), size = Anzahl_Spots, show.legend = "point")) +
  scale_color_manual(values = c("1" = "red", "2" = "blue"),
                     name = "Platz Status",
                     labels = c("1" = "definitiv", "2" = "provisorisch")) +
  scale_shape_manual(values = c("1" = 16, "2" = 17, "3" = 18),
                     name = "Platzart",
                     labels = c("1" = "Standplatz", "2" = "Durchgangsplatz", "3" = "Transitplatz")) +
  scale_size_continuous(name = "Anzahl Spots") +
  theme_minimal() +
  theme(legend.position = "bottom") +
  labs(title = "Spatial distribution of spots for Jenische, Sinti, and Roma in Switzerland",
       subtitle = "Differentiated by Platz Status, Platzart und Anzahl Spots")

# saving plot
save(ggplot, file = here("data", "ggplotMap2.RData")) #saving ggplot in R format
ggsave(file = here("images", "Map2.png")) #saving as image

# Create a scatter plot of the clusters and underlying with map
ggmap(switzerland_map3) +
  geom_sf(data = sf_data_clean_transformed, inherit.aes = FALSE,
          aes(color = cluster), show.legend = "point") +
  scale_color_discrete(name = "Cluster") +
  theme_minimal() +
  labs(title = "Clusters of spots for Jenische, Sinti, and Roma in Switzerland",
       subtitle = "Based on hierarchical clustering")
# saving plot
save(ggplot, file = here("data", "ggplotMap3.RData")) #saving ggplot in R format
ggsave(file = here("images", "Map3.png")) #saving as image