# Making figures for the paper
# Dec 2025

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

#------------------------------------------------------------------------------
# Summary figures
#------------------------------------------------------------------------------
# How many paper from each journal?
journal_summary <-
  papers %>%
  group_by(journal) %>%
  summarise(count = n())

journals <-
  ggplot(journal_summary, aes(x = journal, y = count, fill = journal)) +
  geom_col() +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = journal_cols) +
  coord_flip() +
  theme(legend.position = "none") +
  xlab("")

# How many papers per year?
year_summary <-
  papers %>%
  group_by(year_published) %>%
  summarise(count = n())

years <-
  ggplot(year_summary, aes(x = year_published, y = count)) +
  geom_col(fill = "lightgrey") +
  theme_bw(base_size = 14) +
  xlab("year published")

# combine the two figures
journals + years + plot_annotation(tag_levels = "A")
#--------------------------------------------------------------------------------
# 1. Does the paper use code/data, and is it archived?
# Very small numbers for data not archived is data that is embargoed
# or available on request
#--------------------------------------------------------------------------------
# Make a dataframe for plotting
data_code_by_journal <- 
  papers %>% 
  # select just required variables
  select(journal, data_used, data_availability, code_used, code_archived) %>%
  # reshape the data so that we can plot all four variables together
  pivot_longer(data_used:code_archived, names_to = "var") %>%
  # reorder the factors so the order is correct in the plot
  mutate(var = factor(var, levels = c("data_used", "data_availability", "code_used", "code_archived"))) %>%
  # change the names so they look better on the plots
  mutate(var = case_when(var == "data_used" ~ "data used",
                         var == "data_availability" ~ "data archived",
                         var == "code_used" ~ "code used",
                         var == "code_archived" ~ "code archived")) %>%
  # Recode the available on request as No since there are so few of these
  mutate(value = case_when(value == "No, but they are available on request" ~ "No",
                           TRUE ~ as.character(value))) %>%
  # Get the totals for each variable to plot grouped by journal
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

total <-
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(data_format) %>%
  separate_longer_delim(cols = data_format, delim = ";") %>%
  na.omit() %>%
  group_by(data_format) %>%
  summarise(count = n()) %>% 
  arrange(-count) %>% 
  summarise(sum(count))

# How many are "other"
other_count <- as.numeric(total-topten)

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
  rbind(data.frame(data_format = "other", count = other_count))

# Plot
data_format_plot <-
  ggplot(summary_data_format, aes(x = data_format, y = count)) + 
  geom_col() +
  theme_bw(base_size = 14) +
  coord_flip() +
  # Remove legend title
  theme(legend.title = element_blank()) +
  xlab("data format")
#--------------------------------------------------------------------------------
# Code format
# Create summary dataset for code format
summary_code_format <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(code_format) %>%
  separate_longer_delim(cols = code_format, delim = ";") %>%
  na.omit() %>%
  group_by(code_format) %>%
  summarise(count = n()) %>% 
  arrange(-count)

# Plot
code_format_plot <-
  ggplot(summary_code_format, aes(x = code_format, y = count)) + 
  geom_col() +
  theme_bw(base_size = 14) +
  coord_flip() +
  # Remove legend title
  theme(legend.title = element_blank()) +
  xlab("code format")

#---------------------------------------------
# Combine two plots for data and code into one
(data_format_plot + code_format_plot) + plot_annotation(tag_levels = "A")

#-------------------------------------------------------------------------------
# 3. Are data/code interoperable? 
# B. What programming language is code written in?
# Create summary dataset for code language
#-------------------------------------------------------------------------------
summary_code_language <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(code_language) %>%
  separate_longer_delim(cols = code_language, delim = ";") %>%
  na.omit() %>%
  group_by(code_language) %>%
  summarise(count = n()) %>% 
  arrange(-count)

# Plot
code_language_plot <-
  ggplot(summary_code_language, aes(x = code_language, y = count)) + 
  geom_col() +
  coord_flip() +
  theme_bw(base_size = 14) +
  # Remove legend title
  theme(legend.title = element_blank()) +
  xlab("code language")

#--------------------------------------------------------------------------------
# 4. Where are data/code archived?
#-------------------------------------------------------------------------------
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
  # Add a column to id this as for data
  mutate(type = rep("data", n()))  %>%
  # rename column so the two datasets match
  rename(archive = data_archive)

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
  # Add a column to id this as for code
  mutate(type = rep("code", n())) %>%
  # rename column so the two datasets match
  rename(archive = code_archive)

# Stick the two summary datasets together
summary_all_archive <-
  rbind(summary_data_archive, summary_code_archive) %>%
  # change levels so plot is in correct order (data first)
  mutate(type = factor(type, levels = c("data", "code")))

# Get totals
summary_all_archive %>% group_by(type) %>% summarise(sum(count))

# Plot
archive_plot <-
  ggplot(summary_all_archive, aes(x = archive, y = count)) + 
  geom_col() +
  coord_flip() +
  theme_bw(base_size = 14) +
  # Remove legend title
  theme(legend.title = element_blank()) +
  xlab("") +
  facet_wrap(~type, scales = "free_x") +
  theme(strip.background = element_rect(fill = "white"))

#--------------------------------------------------------------------------------
# 5. Are data/code reusable?
# A. DATA
# Readme
# Complete
#-------------------------------------------------------------------------------
# Make a dataframe for plotting
data_reuse <- 
  papers %>%
  filter(data_availability == "Yes") %>% 
  select(data_README, data_README_scale, data_completeness) %>%
  # reshape the data so that we can plot all four variables together
  pivot_longer(data_README:data_completeness, names_to = "var") %>%
  # reorder the factors so the order is correct in the plot
  mutate(var = factor(var, levels = c("data_README", "data_README_scale", "data_completeness"))) %>%
  # Recode the available on request and embargoed data as No since there are so few of these
  # And shorten the other options to Maybe
  #mutate(value = case_when(value == "No, but they are available on request" ~ "No",
     #                      value == "No, because the data are embargoed" ~ "No",
    #                       value == "Needs specific software or too large" ~ "Maybe",
     #                      value == "Yes, but not all files" ~ "Yes",
     #                      value == "Yes, but not all data" ~ "Yes",
     #                      TRUE ~ as.character(value))) %>%
 # mutate(value = factor(value, levels = c("No", "Maybe", "Yes"))) %>%
  # Get the totals for each variable to plot
  group_by(var, value) %>%
  summarise(papers = n()) %>%
  # Exclude NAs
  na.omit() 

data_reuse_plot <-
  ggplot(data_reuse, aes(x = var, y = papers, fill = value)) + 
  geom_bar(position = "stack", stat = "identity") +
  coord_flip() +
  scale_fill_manual(values = c("#3b2f2f", "#f9cf57", "#56c8d3")) +
  theme_bw(base_size = 14) +
  # Remove legend
  theme(legend.position = "none") +
  xlab("") 

#--------------------------------------------------------------------------------
# 5. Are data/code reusable?
# B. CODE
# Readme
# Complete
Vignette
Annotation
package

#-------------------------------------------------------------------------------

