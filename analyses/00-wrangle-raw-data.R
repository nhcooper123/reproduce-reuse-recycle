# Wrangle data from BES system
# July 2025

# Load libraries
library(tidyverse) # for data manipulation
library(janitor) # for tidying names

# Read in the dataset
raw_data <- read_csv("raw-data/BES article metadata 2015-2024.csv")
# Check it read in properly
glimpse(raw_data)

# Tidy the dataset
# First clean the names to remove spaces etc.
raw_data <- clean_names(raw_data)

# Clean the data
clean_data <- 
  raw_data %>%
# Select only required article types
  filter(display_article_type == "Research Article" |
          display_article_type == "Original Research" | 
          display_article_type == "Standard Paper" | 
          display_article_type == "Original Article" |
          display_article_type == "Original Articles" | 
          display_article_type == "Application" |
          display_article_type == "Practical Tools") %>%
# Remove miscallenous errors in article types
  filter(base_article_type != "Editorial" &
          base_article_type != "Guest Editorial" &
          base_article_type != "Commentary") %>%
# Combine identical article types
  mutate(display_article_type = str_replace_all(display_article_type, "Original Articles", "Research Article")) %>%                           
  mutate(display_article_type = str_replace_all(display_article_type, "Original Article", "Research Article")) %>%  
  mutate(display_article_type = str_replace_all(display_article_type, "Standard Paper", "Research Article")) %>%  
  mutate(display_article_type = str_replace_all(display_article_type, "Original Research", "Research Article")) %>%
# Write journal names in full
  mutate(journal = str_replace_all(journal, "FEC", "Functional Ecology")) %>%                           
  mutate(journal = str_replace_all(journal, "MEE3", "Methods in Ecology and Evolution")) %>%  
  mutate(journal = str_replace_all(journal, "PAN3", "People and Nature")) %>%  
  mutate(journal = str_replace_all(journal, "JANE", "Journal of Animal Ecology")) %>%
  mutate(journal = str_replace_all(journal, "ECE3", "Ecology and Evolution")) %>% 
  #mutate(journal = str_replace_all(journal, "JE", "Journal of Ecology")) %>%  
  mutate(journal = str_replace_all(journal, "JPE", "Journal of Applied Ecology")) %>%
  mutate(journal = str_replace_all(journal, "ESO3", "Ecological Solutions and Evidence")) %>%
# Select only the variables we need
dplyr::select(doi_link, doi, journal, article_type = display_article_type, article_title, 
              date_published = final_vo_r, corresponding_author_country)

# Randomly order the papers
clean_data_random <- clean_data[sample(nrow(clean_data)), ]
  
# Add a paper number  
clean_data_random <- 
  clean_data_random %>%
  mutate(paper_number = 1:nrow(clean_data_random)) %>% 
  # order dataset so paper_number is first
  dplyr::select(paper_number, doi_link:corresponding_author_country)

# Write to file
write_csv(clean_data_random, file = "data/2025-09-29_BES-article-metadata-2015-2024.csv")

# Quick exploratory plots
ggplot(clean_data_random, aes(x = journal, fill = journal)) +
  geom_bar() +
  coord_flip() +
  ylab("number of papers") +
  scale_fill_manual(values = c("lightgreen", "orange", "lightblue", "purple", "turquoise", "red","pink"))

ggplot(clean_data_random, aes(x = journal, fill = article_type)) +
  geom_bar() +
  coord_flip() +
  ylab("Number of papers") +
  scale_fill_manual(values = c("red","yellow","grey"))

ggplot(clean_data_random, aes(x = dmy(date_published))) +
  geom_bar() +
  ylab("Number of papers")
