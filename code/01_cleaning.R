# Load necessary libraries
library(readr)
library(dplyr)
library(here)
library(psych)

# --- 1. Read the raw data ---
# Use the 'here' package to construct file paths robustly
raw_data_path <- here("data/raw/first_wave.csv")
raw_data <- readr::read_csv(raw_data_path)

# View the initial structure of the data
print("Raw Data Dimensions:")
print(dim(raw_data))
print(head(raw_data))

# --- 2. Clean Column Names using Janitor ---
# This step standardizes all column names (e.g., removes capitalization, spaces, special chars)
cleaned_data <- raw_data |>
  janitor::clean_names()

# Convert all binary variables to 0 and 1 and to factors
cleaned_data <- cleaned_data |>
  mutate(across(c(pjq, urgency, adsms, victimisation), ~ as.factor(. - 1)))

describe(cleaned_data)

# --- 3. Save the Processed Data ---

# Define the output path in the 'data/processed' folder
# Make sure the directory exists first
dir.create(here("data/processed"), showWarnings = FALSE)

processed_data_path <- here("data/processed/first_wave_cleaned.csv")

readr::write_csv(cleaned_data, processed_data_path)

print(paste("Successfully saved cleaned data to:", processed_data_path))
