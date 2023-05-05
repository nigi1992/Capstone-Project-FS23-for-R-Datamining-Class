## Descriptive Statistics

# Basic stats of the number of vans at each spot
mean_dev_van_number <- mean(data_sf$Anzahl_Spots)
print(mean_dev_van_number)
stand_dev_van_number <- sd(data_sf$Anzahl_Spots)
print(stand_dev_van_number)
median_van_number <- median(data_sf$Anzahl_Spots)
print(median_van_number)
range_van_number <- range(data_sf$Anzahl_Spots)
print(range_van_number)
mode_van_number <- mode(data_sf$Anzahl_Spots)
print(mode_van_number)

# total capacity of vans at all spots
sum_van <- sum(data_sf$Anzahl_Spots)
print(sum_van)

# Percentage of permanent and temporary spots
value_counts <- table(data_sf$`Platz Status**`)
total_platzstatus <- sum(value_counts)
percentages_platzstatus <- (value_counts/total_platzstatus) * 100
print(percentages_platzstatus)

# Percentage of each kind of spot
value_counts2 <- table(data_sf$`Platzart*`)
total_platzart <- sum(value_counts2)
percentages_platzart <- (value_counts2/total_platzart) * 100
print(percentages_platzart)

# percentage of each combo
contingency_table <- table(data_sf$`Platz Status**`, data_sf$`Platzart*`)
total_contingency <- sum(contingency_table)
percentages_joint <- (contingency_table / total_contingency) * 100
print(percentages_joint)

# Number of spots for each combo
print(contingency_table)


