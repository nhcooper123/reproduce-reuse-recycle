# Making tables for the paper

# Load libraries
library(tidyverse)
 
# Read in the data
papers <- read_csv("data/BES-data-code-hackathon-cleaned_2025-11-16.csv")

#--------------------------------------------------------------------------------
# 1. Does the paper use code/data, and is it archived?
# Very small numbers for data not archived is data that is embargoed
# or available on request
# 2. Are data/code findable and accessible?
#--------------------------------------------------------------------------------
# Numbers overall for using data and/or code  
summary_all_total <- 
  papers %>%
  select(data_used, code_used) %>%
  # reshape the data so that we can plot all fur variables together
  pivot_longer(data_used:code_used, names_to = "var") %>%
  # Get counts
  add_count(var, name = "total") %>%
  add_count(var, value, name = "n") %>%
  # Select only the Yes options
  filter(value == "Yes") %>%
  # Get %
  mutate('%' = round(n/total*100, 2)) %>%
  # Remove duplicates
  distinct()

#write_csv(summary_all_total, file = "tables/table_summary-all-data-code-use.csv")  

# By journal

summary_all_total_journal <- 
  papers %>%
  select(journal, data_used, code_used) %>%
  # reshape the data
  pivot_longer(data_used:code_used, names_to = "var") %>%
  # Group by journal
  group_by(journal) %>%
  # Get counts
  add_count(var, name = "total") %>%
  add_count(var, value, name = "n") %>%
  # Select only the Yes options
  filter(value == "Yes") %>%
  # Get %
  mutate('%' = round(n/total*100, 2)) %>%
  # Remove duplicates
  distinct() %>%
  # order by journal
  arrange(journal)

#write_csv(summary_all_total_journal, file = "tables/table_summary-all-data-code-use-by-journal.csv")

#--------------------------------------------------------------------------------
# 2. Are data/code findable and accessible?
# Only for where there is data used or code used
#--------------------------------------------------------------------------------
# For data, only looking at papers that use data
summary_all_data <- 
  papers %>%
  filter(data_used == "Yes") %>%
  select(data_availability, data_link, data_download, data_open) %>%
  # reshape the data
  pivot_longer(data_availability:data_open, names_to = "var") %>%
  # Recode the available on request and embargoed data as No since there are so few of these
  # And shorten the other options to Maybe
  mutate(value = case_when(value == "No, but they are available on request" ~ "No",
                           value == "No, because the data are embargoed" ~ "No",
                           value == "Maybe if I had the right software" ~ "Maybe",
                           value == "Yes, but not all files" ~ "Yes",
                           value == "Yes, but not all data" ~ "Yes",
                           value == "Needs specific software or too large" ~ "Maybe",
                           TRUE ~ as.character(value))) %>%
  # Get counts
  add_count(var, name = "total") %>%
  add_count(var, value, name = "n") %>%
  # Just keep the yes options
  filter(value == "Yes") %>%
  # Remove duplicates
  distinct() %>%
  # Get percentages
  mutate('%' = round(n/total*100, 2))

#write_csv(summary_all_data, file = "tables/table_summary-all-data-find-access.csv")

# By journal
summary_all_data_journal <- 
  papers %>%
  filter(data_used == "Yes") %>%
  select(journal, data_availability, data_link, data_download, data_open) %>%
  # reshape the data
  pivot_longer(data_availability:data_open, names_to = "var") %>%
  # Recode the available on request and embargoed data as No since there are so few of these
  # And shorten the other options to Maybe
  mutate(value = case_when(value == "No, but they are available on request" ~ "No",
                           value == "No, because the data are embargoed" ~ "No",
                           value == "Maybe if I had the right software" ~ "Maybe",
                           value == "Yes, but not all files" ~ "Yes",
                           value == "Yes, but not all data" ~ "Yes",
                           value == "Needs specific software or too large" ~ "Maybe",
                           TRUE ~ as.character(value))) %>%
  # Group by journal
  group_by(journal) %>%
  # Get counts
  add_count(var, name = "total") %>%
  add_count(var, value, name = "n") %>%
  # Just keep the yes options
  filter(value == "Yes") %>%
  # Remove duplicates
  distinct() %>%
  # Get percentages
  mutate('%' = round(n/total*100, 2)) %>%
  # order by journal
  arrange(journal)

#write_csv(summary_all_data_journal, file = "tables/table_summary-all-data-find-access-by-journal.csv")

#------------------
# For code, only looking at papers that use code
summary_all_code <- 
  papers %>%
  filter(code_used == "Yes") %>%
  select(code_archived, code_availability, code_link, code_download, code_open) %>%
  # reshape the data
  pivot_longer(code_archived:code_open, names_to = "var") %>%
  # Recode the available on request and embargoed data as No since there are so few of these
  # And shorten the other options to Maybe
  mutate(value = case_when(value == "No, but they are available on request" ~ "No",
                           value == "No, because the data are embargoed" ~ "No",
                           value == "Maybe if I had the right software" ~ "Maybe",
                           value == "Yes, but not all files" ~ "Yes",
                           value == "Yes, but not all data" ~ "Yes",
                           value == "Needs specific software or too large" ~ "Maybe",
                           TRUE ~ as.character(value))) %>%
  # Get counts
  add_count(var, name = "total") %>%
  add_count(var, value, name = "n") %>%
  # Just keep the yes options
  filter(value == "Yes") %>%
  # Remove duplicates
  distinct() %>%
  # Get percentages
  mutate('%' = round(n/total*100, 2))

#write_csv(summary_all_code, file = "tables/table_summary-all-code-find-access.csv")

# By journal
summary_all_code_journal <- 
  papers %>%
  filter(code_used == "Yes") %>%
  select(journal, code_archived, code_availability, code_link, code_download, code_open) %>%
  # reshape the data
  pivot_longer(code_archived:code_open, names_to = "var") %>%
  # Recode the available on request and embargoed data as No since there are so few of these
  # And shorten the other options to Maybe
  mutate(value = case_when(value == "Maybe if I had the right software" ~ "Maybe",
                           value == "Yes, but not all files" ~ "Yes",
                           value == "Yes, but not all data" ~ "Yes",
                           value == "Needs specific software or too large" ~ "Maybe",
                           TRUE ~ as.character(value))) %>%
  # Group by journal
  group_by(journal) %>%
  # Get counts
  add_count(var, name = "total") %>%
  add_count(var, value, name = "n") %>%
  # Just keep the yes options
  filter(value == "Yes") %>%
  # Remove duplicates
  distinct() %>%
  # Get percentages
  mutate('%' = round(n/total*100, 2))%>%
  # order by journal
  arrange(journal)

#write_csv(summary_all_code_journal, file = "tables/table_summary-all-code-find-access-by-journal.csv")

#------------------
# For code, only looking at papers that ARCHIVED code
summary_all_code_archived <- 
  papers %>%
  filter(code_archived == "Yes") %>%
  select(code_availability, code_link, code_download, code_open) %>%
  # reshape the data
  pivot_longer(code_availability:code_open, names_to = "var") %>%
  # Recode the available on request and embargoed data as No since there are so few of these
  # And shorten the other options to Maybe
  mutate(value = case_when(value == "No, but they are available on request" ~ "No",
                           value == "No, because the data are embargoed" ~ "No",
                           value == "Maybe if I had the right software" ~ "Maybe",
                           value == "Yes, but not all files" ~ "Yes",
                           value == "Yes, but not all data" ~ "Yes",
                           value == "Needs specific software or too large" ~ "Maybe",
                           TRUE ~ as.character(value))) %>%
  # Get counts
  add_count(var, name = "total") %>%
  add_count(var, value, name = "n") %>%
  # Just keep the yes options
  filter(value == "Yes") %>%
  # Remove duplicates
  distinct() %>%
  # Get percentages
  mutate('%' = round(n/total*100, 2))

#write_csv(summary_all_code_archived, file = "tables/table_summary-archived-code-find-access.csv")

# By journal
summary_all_code_archived_journal <- 
  papers %>%
  filter(code_archived == "Yes") %>%
  select(journal, code_availability, code_link, code_download, code_open) %>%
  # reshape the data
  pivot_longer(code_availability:code_open, names_to = "var") %>%
  # Recode the available on request and embargoed data as No since there are so few of these
  # And shorten the other options to Maybe
  mutate(value = case_when(value == "No, but they are available on request" ~ "No",
                           value == "No, because the data are embargoed" ~ "No",
                           value == "Maybe if I had the right software" ~ "Maybe",
                           value == "Yes, but not all files" ~ "Yes",
                           value == "Yes, but not all data" ~ "Yes",
                           value == "Needs specific software or too large" ~ "Maybe",
                           TRUE ~ as.character(value))) %>%
  # Group by journal
  group_by(journal) %>%
  # Get counts
  add_count(var, name = "total") %>%
  add_count(var, value, name = "n") %>%
  # Just keep the yes options
  filter(value == "Yes") %>%
  # Remove duplicates
  distinct() %>%
  # Get percentages
  mutate('%' = round(n/total*100, 2)) %>%
  # order by journal
  arrange(journal)

#write_csv(summary_all_code_archived_journal, file = "tables/table_summary-archived-code-find-access-by-journal.csv")

#--------------------------------------------------------------------------------
# 3. Are data/code interoperable?
# A. What format are they saved in? 
#--------------------------------------------------------------------------------  
# Data format
# First work out how many entries are not in the top ten 
# these should be added to the plot as "other"
topten <-
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(data_format) %>%
  separate_longer_delim(cols = data_format, delim = ";") %>%
  na.omit() %>%
  group_by(data_format) %>%
  summarise(count = n()) %>% 
  arrange(-count) %>% 
  slice(1:10) %>%
  summarise(sum(count))

total_df <-
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(data_format) %>%
  separate_longer_delim(cols = data_format, delim = ";") %>%
  na.omit() %>%
  summarise(n())

# How many are "other"
other_count <- as.numeric(total_df-topten)

# Create summary dataset for data format
# Select just the top 10 or it gets very large
summary_data_format <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(data_format) %>%
  separate_longer_delim(cols = data_format, delim = ";") %>%
  na.omit() %>%
  # Combine RDS and Rdata
  mutate(data_format = case_when(data_format == ".RDS" | data_format == ".Rdata" 
                                 ~ ".rda/.rdata/.rds",
                                 TRUE ~ as.character(data_format))) %>%
  group_by(data_format) %>%
  summarise(count = n()) %>%
  # arrange in reverse order
  arrange(-count) %>%
  # select just top ten
  slice(1:10) %>%
  # add "other" option
  rbind(data.frame(data_format = "other", count = other_count)) %>% 
  group_by(data_format, count) %>% 
  summarise(percent = as.numeric(round(count/total_df*100, 3)))

#write_csv(summary_data_format, file = "tables/table_summary-data-format.csv")

#--------------------------------------------------------------------------------
# Code format
# Get total numbers
total_cf <-
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(code_format) %>%
  separate_longer_delim(cols = code_format, delim = ";") %>%
  na.omit() %>%
  summarise(n())

# Create summary dataset for code format
summary_code_format <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(code_format) %>%
  separate_longer_delim(cols = code_format, delim = ";") %>%
  na.omit() %>%
  group_by(code_format) %>%
  summarise(count = n()) %>% 
  arrange(-count) %>%
  group_by(code_format,count) %>% 
  summarise(percent = as.numeric(round(count/total_cf*100, 3)))

#write_csv(summary_code_format, file = "tables/table_summary-code-format.csv")

#-------------------------------------------------------------------------------
# 3. Are data/code interoperable? 
# B. What programming language is code written in?
# Create summary dataset for code language
#-------------------------------------------------------------------------------
# Get total numbers
total_cl <-
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(code_language) %>%
  separate_longer_delim(cols = code_language, delim = ";") %>%
  na.omit() %>%
  summarise(n()) 

# Create summary table
summary_code_language <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(code_language) %>%
  separate_longer_delim(cols = code_language, delim = ";") %>%
  na.omit() %>%
  group_by(code_language) %>%
  summarise(count = n()) %>% 
  arrange(-count) %>%
  group_by(code_language,count) %>% 
  summarise(percent = as.numeric(round(count/total_cl*100, 3)))

#write_csv(summary_code_language, file = "tables/table_summary-code-language.csv")

#--------------------------------------------------------------------------------
# 4. Where are data/code archived?
#-------------------------------------------------------------------------------
# Data
# Get totals
total_da <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(data_archive) %>%
  separate_longer_delim(cols = data_archive, delim = ";") %>%
  na.omit() %>%
  summarise(n()) 
 
# Create summary dataset for data archive
summary_data_archive <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(data_archive) %>%
  separate_longer_delim(cols = data_archive, delim = ";") %>%
  na.omit() %>%
  group_by(data_archive) %>%
  summarise(count = n()) %>% 
  arrange(-count) %>%
  group_by(data_archive,count) %>% 
  summarise(percent = as.numeric(round(count/total_da*100, 3)))

#write_csv(summary_data_archive, file = "tables/table_summary-data-archive.csv")

#-----
# Code
# Get totals
total_ca <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(code_archive) %>%
  separate_longer_delim(cols = code_archive, delim = ";") %>%
  na.omit() %>%
  summarise(n())

# Create summary dataset for code archive
summary_code_archive <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(code_archive) %>%
  separate_longer_delim(cols = code_archive, delim = ";") %>%
  na.omit() %>%
  group_by(code_archive) %>%
  summarise(count = n()) %>% 
  arrange(-count) %>%
  group_by(code_archive,count) %>% 
  summarise(percent = as.numeric(round(count/total_ca*100, 3)))

#write_csv(summary_code_archive, file = "tables/table_summary-code-archive.csv")

#--------------------------------------------------------------------------------
# 5. Are data/code reusable?
# README + completeness + annotation
#-------------------------------------------------------------------------------
# A. README
#-----------------
# data
# Don't add % for this as it's not clear what total we 
# want to get % from (total of papers using data, or with archived data etc.)
# Also keep NAs for the same reason
data_readme <- 
  papers %>%
  filter(data_availability == "Yes") %>% 
  select(data_README) %>%
  group_by(data_README) %>%
  summarise(papers = n())

#write_csv(data_readme, file = "tables/table_summary-data-readme.csv")

# code
code_readme <- 
  papers %>%
  filter(code_archived == "Yes") %>% 
  select(code_README) %>%
  group_by(code_README) %>%
  summarise(papers = n())

#write_csv(code_readme, file = "tables/table_summary-code-readme.csv")

#--------------------------------------------------------------------
# Scales for README/completeness/annotation
# Get median scores
papers %>% summarise(median(data_README_scale, na.rm = TRUE))
papers %>% summarise(median(code_README_scale, na.rm = TRUE))
papers %>% summarise(median(code_annotation_scale, na.rm = TRUE))

#--------------------------------------------------------------------------------
# 6. Are data/code citable?
# DOI + license + license type
#-------------------------------------------------------------------------------
# A. DOI
#-----------------
# Don't add % for this as it's not clear what total we 
# want to get % from (total of papers using data, or with archived data etc.)
# Also keep NAs for the same reason
# data
data_doi <- 
  papers %>%
  filter(data_availability == "Yes") %>% 
  select(data_doi) %>%
  group_by(data_doi) %>%
  summarise(count = n())

#write_csv(data_doi, file = "tables/table_summary-data-doi.csv")

# code
code_doi <- 
  papers %>%
  filter(code_archived == "Yes") %>% 
  select(code_doi) %>%
  group_by(code_doi) %>%
  summarise(count = n())

#write_csv(code_doi, file = "tables/table_summary-code-doi.csv")

#-----------------
# B. License
#-----------------
# data
data_license <- 
  papers %>%
  filter(data_availability == "Yes") %>% 
  select(data_license) %>%
  group_by(data_license) %>%
  summarise(count = n())

#write_csv(data_license, file = "tables/table_summary-data-license.csv")

# code
code_license <- 
  papers %>%
  filter(code_archived == "Yes") %>% 
  select(code_license) %>%
  group_by(code_license) %>%
  summarise(count = n())

#write_csv(code_license, file = "tables/table_summary-code-license.csv")

#---------------------
# C. License type
# --------------------
# data
data_license_type <-
  papers %>% 
  filter(data_used == "Yes" & data_license_type != "No") %>% 
  select(data_license_type) %>%
  na.omit() %>%
  group_by(data_license_type)  %>%
  summarise(count  = n())

#write_csv(data_license_type, file = "tables/table_summary-data-license-type.csv")

code_license_type <-
  papers %>% 
  filter(code_archived == "Yes") %>% 
  select(code_license_type) %>%
  group_by(code_license_type)  %>%
  summarise(count = n()) 

#write_csv(code_license_type, file = "tables/table_summary-code-license-type.csv")
