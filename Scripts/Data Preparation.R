# Data Preparation
# Continuing with .xlsx Excel doc data, since API data extraction and preparation failed

# loading appropriate packages
install.packages("readxl")
library(readxl)
install.packages("gh")
library(gh)

# importing .xlsx data, don't forget to include in github
getwd() # set working directory appropriately with command setwd()

# data available under the following url:
browseURL(url = "https://data.geo.admin.ch/browser/index.html#/collections/ch.bak.halteplaetze-jenische_sinti_roma/items/halteplaetze-jenische_sinti_roma?.asset=asset-halteplaetze-jenische_sinti_roma_2056.xlsx.zip")

# downloading and temporarily storing file
url2 <- "https://data.geo.admin.ch/browser/index.html#/collections/ch.bak.halteplaetze-jenische_sinti_roma/items/halteplaetze-jenische_sinti_roma?.asset=asset-halteplaetze-jenische_sinti_roma_2056.xlsx.zip"
temp_file <- tempfile()
download.file(url2, temp_file)
#unzipping file
unzip(temp_file, "halteplaetze-jenische_sinti_roma_2056.xlsx") #error message, don't know what is wrong
df <- read_excel("halteplaetze-jenische_sinti_roma_2056.xlsx") # weirdly this command works flawlessly

# pushing excel file to Github
gh(file = "/Users/nicolaswaser/New-project-GitHub-first/R/Data Mining in R/Capstone-Project-FS23-for-R-Datamining-Class/halteplaetze-jenische_sinti_roma_2056.csv", repo = "nigi1992/Capstone-Project-FS23-for-R-Datamining-Class", message = "pushing excel file to github for further use")
# also error message, third parties will have to download file themselves from provided url or Github Repo, continuing the old fashioned way

# reading data old fashioned way
data2 = read.table("halteplaetze-jenische_sinti_roma_2056.xlsx",sep=";",header=T)
# R seems unable to process .xlsx file, have to manually convert into .csv first
data3 = read.table("halteplaetze-jenische_sinti_roma_2056.csv",sep=";",header=T)
head(data)
# data3 works

# NA values have to be removed
# Identify missing values
missing_values <- is.na(df)

# remove missing values
data_clean <- df[complete.cases(data3),]

