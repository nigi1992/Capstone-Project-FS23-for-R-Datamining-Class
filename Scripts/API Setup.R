# testing data extraction of chosen API data set

library(tidyverse)
install.packages("httr")
install.packages("jsonlite")
library(httr)
library(jsonlite)

# The website
browseURL(url = "https://www.geocat.ch/geonetwork/srv/ger/catalog.search#/metadata/51193e6b-d3d6-4202-8d1c-8bdb49f59535")
# The API adress
base_url <- "https://api3.geo.admin.ch/rest/services/api/MapServer/ch.bak.halteplaetze-jenische_sinti_roma"



# ChatGpt Proposal

# Specify the API endpoint and parameters
params <- list(f = "json")

# Send the API request and extract the response
response <- GET(base_url, query = params)
json_data <- content(response, "text") # gives encoding warning, automatically switches to UTF-8. Problem?
data <- fromJSON(json_data)

# Extract the relevant data
features <- data$fields
subfeatures <- data$fields$values

# table to be filled later with values
fahrende_table <- matrix(nrow = 21, ncol = 1, byrow = T)
location_data <- data.frame(features)

# Approach 1, ChatGpt Proposition
for (i in 1:length(features)) {
  location <- features[[i]]
  location_data[i,] <- rbind(location_data, location)
} # error message: invalid list argument: all variables should have the same length

# Approach 2, from class exercise
# loop through contents list and storing name and values
for (i in 1:length(features)) {
  location <- features[[i]]
  location_data[i,] <- c(features$name, features$values)
} # error message: number of items to replace is not a multiple of replacement length

# Clean and format the data
location <- subset(location_data, select = c("adresse", "platzart", "gemeinde", "platz_status", "y_koordinate", "kanton", "anzahl_stellplaetze", "x_koordinate", "standort", "platzart_de", "bemerkungen_de"))
# error message: subset not defined
location_data$x <- as.numeric(location_data$x)
location_data$y <- as.numeric(location_data$y)

# Print the data
print(location_data)

## NO GOOD. Too many unsolvable error messages.





# Approach with code snippets from Class exercise + geocoding solution exercise

# Get Request
Fahrende_response <- httr::GET(url = base_url)

# Check Status Code
http_status(Fahrende_response)

#  Use rsonlite::fromJSON()
r_json <- fromJSON(httr::content(Fahrende_response, as = "text"))

# Or parsing the content
fahrende_data <- httr::content(Fahrende_response)

# Loop through response pages
fahrende_df <- data.frame()
for (x in 1:21) # why 21? I don't know there is 21 values?

# Extracting content of the fahrende_response  
content <- content(Fahrende_response, as = "parsed")

# empty matrix to be filled with content data
fahrende_table <- matrix(nrow = 21, ncol = 4, byrow = T)

# check for missing values and empty string + cleaning
any(is.na(content))
any_empty_strings <- any(apply(content, 1, function(x) any(nchar(x) == 0)))
any_empty_strings

# cleaning data (removing html tags using regexpr)
fahrende_df <- fahrende_df %>% 
  mutate(V3 = gsub("<.*?>", "", V3)) %>% 
  # NAs
  mutate(V1 = if_else(is.na(V1), "MISSING_TEXT", V1)) %>%  # Na handling
  mutate(V2 = if_else(is.na(V2), "MISSING_TEXT", V2)) %>%  # Na handling
  mutate(V3 = if_else(is.na(V3), "MISSING_TEXT", V3)) %>%  # Na handling
  # empty stings
  mutate(across(everything(), ~ if_else(.x == "", "MISSING_TEXT", .x), .names = 'new_{.col}'))

# check for missing values and empty string (again)
any(is.na(fahrende_df))
any_empty_strings <- any(apply(fahrende_df, 1, function(x) any(nchar(x) == 0)))
any_empty_strings

## No good either. Too many unsolvable error messages. Furthermore the list that the API gives is structured weirdly.
## The columns are ordered in rows and the values that are supposed to be ordered in rows are arranged in a single cell.
## Also, for some reason only five out of 45 elements are part of the API List.
## Luckily, there is a .xlsx Excel doc, in which all the elements are contained and prepared in a orderly fashion.





# asking for consent
httr::GET(base_url, 
                      add_headers(
                        From = "nicolas.waser@icloud.com",
                        'User-Agent' = user_agent))




