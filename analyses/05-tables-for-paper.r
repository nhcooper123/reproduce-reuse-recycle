# Making tables for the paper

# Load libraries
library(tidyverse)

# Read in the data
papers <- read_csv(here("data/BES-data-code-hackathon-cleaned_2025-11-16.csv"))

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

kable(summary_all_total)  


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

kable(summary_all_total_journal)

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

kable(summary_all_data)

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

kable(summary_all_data_journal)

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

kable(summary_all_code)

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

kable(summary_all_code_journal)

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

kable(summary_all_code_archived)

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

kable(summary_all_code_archived_journal)
