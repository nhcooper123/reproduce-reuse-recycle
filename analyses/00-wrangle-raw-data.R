# Wrangle data from BES system
# Sept 2025

# Load libraries
library(tidyverse) # for data manipulation and plotting
library(janitor) # for tidying names

# Read in the dataset
raw_data <- read_csv("raw-data/BES_2015-2024_article_data_2025-09-02.csv")
# Check it read in properly
glimpse(raw_data)

# Tidy the dataset
# First clean the names to remove spaces etc.
raw_data <- clean_names(raw_data)

# Clean the data
clean_data <- 
  raw_data %>%
# Rename article 
  mutate(category_display_article_type = 
          case_when(category_display_article_type == "Long-term Studies in Animal Ecology" ~ "Long Term Study",
                    category_display_article_type == "Original Article" ~ "Research Article",
                    category_display_article_type == "Special Issue Article" ~ "Research Article",
                    category_display_article_type == "Standard Paper" ~ "Research Article",                               
                    TRUE ~ as.character(category_display_article_type))) %>%
# Select only required article types
  # i.e. Research Article, Applications, Practical Tools, Data Articles and Long Term Study

  # Excludes Biological Flora, Commentary, Concept, Correction,
  # Correspondence, Corrigendum, Editorial, Editorial Note, Erratum,
  # Essay Review, FE Spotlight, Forum, From Practice,
  # Guest Editorial, How To, In Focus, Mini review, Perspectives,
  # Policy Directions, Practice Insights, Practitioner Perspective,
  # Registered Reports, Research Highlights, Research Methods Guides,
  # Review, Review and Synthesis, Synthesis.
  
  filter(category_display_article_type == "Research Article" |
           category_display_article_type == "Application" | 
           category_display_article_type == "Data Article" | 
           category_display_article_type == "Long Term Study" |
           category_display_article_type == "Practical Tools") %>%
# Write journal names in full
  mutate(journal = 
           case_when(journal == "FEC" ~ "Functional Ecology",
                     journal == "MEE3" ~ "Methods in Ecology and Evolution",
                     journal == "PAN3" ~ "People and Nature",
                     journal == "JANE" ~ "Journal of Animal Ecology",
                     journal == "JEC" ~ "Journal of Ecology", 
                     journal == "JPE" ~ "Journal of Applied Ecology",
                     journal == "ESO3" ~ "Ecological Solutions and Evidence",
                     TRUE ~ as.character(journal))) %>%
# Select only the variables we need
dplyr::select(doi_link, doi, journal, article_type = category_display_article_type, article_title, 
              date_published = first_online_actual, corresponding_author_country)

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
  scale_fill_manual(values = c("red","yellow","grey", "pink", "palegreen"))

ggplot(clean_data_random, aes(x = dmy(date_published), colour = journal)) +
  geom_density() +
  ylab("Number of papers")
geom_line()