# Making figures for the paper

# Load libraries
library(tidyverse)
library(patchwork)

# Build colour scheme for the journals
journal_cols <- c("#9FE2BF", # ESE
                  "#F4C430", # Functional Ecology
                  "#2AAA8A", # J Applied Ecology
                  "#C3B1E1", # J Animal Ecology
                  "#A7C7E7", # J Ecology
                  "#DE3163", # MEE
                  "#F2D2BD") # People and Nature

# Read in the data
papers <- read_csv("data/BES-data-code-hackathon-cleaned_2025-11-16.csv")

#--------------------------------------------------------------------------------
# 1. Does the paper use code/data, and is it archived?
# Very small numbers for data not archived is data that is embargoed
# or available on request
#--------------------------------------------------------------------------------
# Make a dataframe for plotting
data_code_by_journal <- 
  papers %>% 
  select(journal, data_used, data_availability, code_used, code_archived) %>%
  # reshape the data so that we can plot all fur variables together
  pivot_longer(data_used:code_archived, names_to = "var") %>%
  # reorder the factors so the order is correct in the plot
  mutate(var = factor(var, levels = c("data_used", "data_availability", "code_used", "code_archived"))) %>%
  # change the names
  mutate(var = case_when(var == "data_used" ~ "data used",
                         var == "data_availability" ~ "data archived",
                         var == "code_used" ~ "code used",
                         var == "code_archived" ~ "code archived")) %>%
  # Recode the available on request as No since there are so few of these
  mutate(value = case_when(value == "No, but they are available on request" ~ "No",
                           TRUE ~ as.character(value))) %>%
  # Get the totals for each variable to plot
  group_by(journal, var, value) %>%
  summarise(papers = n()) %>%
  # Exclude NAs
  na.omit() 

# Plot
ggplot(data_code_by_journal, aes(x = var, y = papers, fill = value)) + 
  geom_bar(position = "stack", stat = "identity") + 
  coord_flip() +
  scale_fill_manual(values = c("#3b2f2f", "#f9cf57", "#56c8d3")) +
  theme_bw(base_size = 14) +
  # Remove legend title
  theme(legend.title = element_blank()) +
  xlab("")

#--------------------------------------------------------------------------------
# 2. Are data/code findable and accessible?
# A. DATA
#--------------------------------------------------------------------------------
# Make a dataframe for plotting
data_FA <- 
  papers %>%
  select(journal, 
         data_availability, data_link, data_download, data_open) %>%
  # reshape the data so that we can plot all fur variables together
  pivot_longer(data_availability:data_open, names_to = "var") %>%
  # change the names
  mutate(var = case_when(var == "data_availability" ~ "data statement",
                         var == "data_link" ~ "data link",
                         var == "data_download" ~ "data download",
                         var == "data_open" ~ "data open")) %>%
  # reorder the factors so the order is correct in the plot
  mutate(var = factor(var, levels = c("data statement", "data link", 
                                      "data download", "data open"))) %>%
  # Recode the available on request and embargoed data as No since there are so few of these
  # And shorten the other options to Maybe
  mutate(value = case_when(value == "No, but they are available on request" ~ "No",
                           value == "No, because the data are embargoed" ~ "No",
                           value == "Needs specific software or too large" ~ "Maybe",
                           value == "Yes, but not all files" ~ "Yes",
                           value == "Yes, but not all data" ~ "Yes",
                           TRUE ~ as.character(value))) %>%
  mutate(value = factor(value, levels = c("No", "Maybe", "Yes"))) %>%
  # Get the totals for each variable to plot
  group_by(journal, var, value) %>%
  summarise(papers = n()) %>%
  # Exclude NAs
  na.omit() 

dataFAplot <-
  ggplot(data_FA, aes(x = var, y = papers, fill = value)) + 
  geom_bar(position = "stack", stat = "identity") +
  coord_flip() +
  scale_fill_manual(values = c("#3b2f2f", "#f9cf57", "#56c8d3")) +
  theme_bw(base_size = 14) +
  # Remove legend
  theme(legend.position = "none") +
  xlab("") 

#--------------------------------------------------------------------------------
# 2. Are data/code findable and accessible?
# B. CODE
#--------------------------------------------------------------------------------
code_FA <- 
  papers %>%
  select(journal, 
         code_archived, code_availability, code_link, code_download, code_open) %>%
  # reshape the data so that we can plot all fur variables together
  pivot_longer(code_availability:code_open, names_to = "var") %>%
  # change the names
  mutate(var = case_when(var == "code_availability" ~ "code statement",
                         var == "code_link" ~ "code link",
                         var == "code_download" ~ "code download",
                         var == "code_open" ~ "code open")) %>%
  # reorder the factors so the order is correct in the plot
  mutate(var = factor(var, levels = c("code statement", 
                                      "code link", "code download", "code open"))) %>%
  # Recode the available on request and embargoed data as No since there are so few of these
  # And shorten the other options to Maybe
  mutate(value = case_when(value == "No, but they are available on request" ~ "No",
                           value == "No, because the data are embargoed" ~ "No",
                           value == "Maybe if I had the right software" ~ "Maybe",
                           value == "Yes, but not all files" ~ "Yes",
                           TRUE ~ as.character(value))) %>%
  mutate(value = factor(value, levels = c("No", "Maybe", "Yes"))) %>%
  # Get the totals for each variable to plot
  group_by(journal, var, value) %>%
  summarise(papers = n()) %>%
  # Exclude NAs
  na.omit() 

# Plot
codeFAplot <-
  ggplot(code_FA, aes(x = var, y = papers, fill = value)) + 
  geom_bar(position = "stack", stat = "identity") +
  coord_flip() +
  scale_fill_manual(values = c("#3b2f2f", "#f9cf57", "#56c8d3")) +
  theme_bw(base_size = 14) +
  # Remove legend title
  theme(legend.title = element_blank()) +
  xlab("")

# Combine the two
dataFAplot + codeFAplot + plot_annotation(tag_levels = 'A')

#--------------------------------------------------------------------------------
# 3. Are data/code interoperable?
# What format are they saved in? What programming language is code written in?
#--------------------------------------------------------------------------------  

ggplot(papers, aes(x = data_format)) + 
  geom_bar() +
  coord_flip() +
  scale_fill_manual(values = c("#3b2f2f", "#f9cf57", "#56c8d3")) +
  theme_bw(base_size = 14) +
  # Remove legend title
  theme(legend.title = element_blank()) +
  xlab("")


summary_data_format <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(data_format) %>%
  separate_longer_delim(cols = data_format, delim = ";") %>%
  na.omit() %>%
  group_by(data_format) %>%
  summarise(count = n()) %>% 
  arrange(-count) %>% 
  slice(1:10)

kable(summary_data_format)