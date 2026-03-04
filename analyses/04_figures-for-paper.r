# Making figures for the paper
# This script makes figures 1-7 in the main text and figure S16.

# Load libraries
library(tidyverse) # for data manipulation and plotting
library(patchwork) # for multipanel plots

# Build colour scheme for the journals
journal_cols <- c("#A2DACC", # ESE
                  "#EDC04E", # Functional Ecology
                  "#AC92ED", # J Animal Ecology
                  "#45B599", # J Applied Ecology
                  "#AECEF6", # J Ecology
                  "#e3626f", # MEE
                  "#DDAC93") # People and Nature

# Read in the data
papers <- read_csv("data/BES-data-code-hackathon-cleaned_2025-12-01.csv")

#------------------------------------------------------------------------------
# 1. Papers per journal/year
#------------------------------------------------------------------------------
# How many paper from each journal?
journal_summary <-
  papers %>%
  group_by(journal) %>%
  summarise(count = n())

# Make the figure
journals <-
  ggplot(journal_summary, aes(x = journal, y = count, fill = journal)) +
  geom_col() +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = journal_cols) +
  coord_flip() +
  theme(legend.position = "none") +
  xlab("") +
  ylab("papers")

# How many papers per year?
year_summary <-
  papers %>%
  group_by(year_published) %>%
  summarise(count = n())

# Make the figure
years <-
  ggplot(year_summary, aes(x = year_published, y = count)) +
  geom_col(fill = "lightgrey") +
  theme_bw(base_size = 14) +
  xlab("year published") +
  scale_x_continuous(breaks = 2017:2024) +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5))

# combine the two figures
fig1 <- journals + years + plot_annotation(tag_levels = "A")

# Save figure
ggsave(fig1, file = "figures/fig1_summary-journal-year.jpg", width = 8, height = 4)

#--------------------------------------------------------------------------------
# 2. Does the paper use code/data, and is it archived?
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
fig2 <- ggplot(data_code_by_journal, aes(x = var, y = papers, fill = value)) + 
  geom_bar(position = "stack", stat = "identity") + 
  coord_flip() +
  scale_fill_manual(values = c("#3b2f2f", "#f9cf57", "#56c8d3")) +
  theme_bw(base_size = 14) +
  # Remove legend title
  theme(legend.title = element_blank()) +
  xlab("")

# Save figure
ggsave(fig2, file = "figures/fig2_used-archived.jpg", width = 6, height = 4)

#--------------------------------------------------------------------------------
# 3. Where are data/code archived?
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
  mutate(type = factor(type, levels = c("data", "code"))) %>%
  # change name of github option
  mutate(archive = case_when(archive == "GitHub, GitLab, Codeberg or similar platform" ~ "Git hosting services",
         TRUE ~ as.character(archive))) %>%
  # remove personal website as it only has two entries
  filter(archive != "Personal website")

# Get totals
summary_all_archive %>% group_by(type) %>% summarise(sum(count))

# Plot
fig3 <-
  ggplot(summary_all_archive, aes(x = forcats::fct_reorder(archive, count), y = count)) + 
  geom_col(fill = "lightgrey") +
  coord_flip() +
  theme_bw(base_size = 14) +
  # Remove legend title
  theme(legend.title = element_blank()) +
  xlab("") +
  ylab("files") +
  facet_wrap(~type, scales = "free_x") +
  theme(strip.background = element_rect(fill = "white")) +
  expand_limits(y = c(0,300))

# Save figure
ggsave(fig3, file = "figures/fig3_archive-locations.jpg", width = 8, height = 4)

#--------------------------------------------------------------------------------
# 4. Are data/code findable and accessible?
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
  mutate(var = case_when(var == "data_availability" ~ "statement",
                         var == "data_link" ~ "locate",
                         var == "data_download" ~ "download",
                         var == "data_open" ~ "open")) %>%
  # reorder the factors so the order is correct in the plot
  mutate(var = factor(var, levels = c("open", "download", "locate", "statement"))) %>%
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
  na.omit() %>%
  # Add a column to id this as for data
  mutate(type = rep("data", n()))

#--------------------------------------------------------------------------------
# B. CODE
#--------------------------------------------------------------------------------
code_FA <- 
  papers %>%
  select(journal, 
         code_archived, code_availability, code_link, code_download, code_open) %>%
  # reshape the data so that we can plot all fur variables together
  pivot_longer(code_availability:code_open, names_to = "var") %>%
  # change the names
  mutate(var = case_when(var == "code_availability" ~ "statement",
                         var == "code_link" ~ "locate",
                         var == "code_download" ~ "download",
                         var == "code_open" ~ "open")) %>%
  # reorder the factors so the order is correct in the plot
  mutate(var = factor(var, levels = c("open", "download", "locate", "statement"))) %>%
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
  na.omit() %>%
  # Add a column to id this as for code
  mutate(type = rep("code", n()))

# Stick the two summary datasets together
summary_all_FA <-
  rbind(data_FA, code_FA) %>%
  # change levels so plot is in correct order (data first)
  mutate(type = factor(type, levels = c("data", "code")))

# Plot
fig4 <-
  ggplot(summary_all_FA, aes(x = var, y = papers, fill = value)) + 
  geom_bar(position = "stack", stat = "identity") +
  coord_flip() +
  scale_fill_manual(values = c("#3b2f2f", "#f9cf57", "#56c8d3")) +
  theme_bw(base_size = 14) +
  # Remove legend title
  theme(legend.title = element_blank()) +
  xlab("") +
  facet_wrap(~type, scales = "free_x") +
  theme(strip.background = element_rect(fill = "white"))

# Save figure
ggsave(fig4, file = "figures/fig4_locate-download-open.jpg", width = 8, height = 4)

#--------------------------------------------------------------------------------
# 5. What file extensions are files saved with? 
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

# How many are "other"?
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
  rbind(data.frame(data_format = "Other", count = other_count)) %>%
  # Add a column to id this as for data
  mutate(type = rep("data", n()))  %>%
  # rename column so the two datasets match
  rename(format = data_format)

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
  # Add a column to id this as for data
  mutate(type = rep("code", n()))  %>%
  # rename column so the two datasets match
  rename(format = code_format)

# Stick the two summary datasets together
summary_all_format <-
  rbind(summary_data_format, summary_code_format) %>%
  # change levels so plot is in correct order (data first)
  mutate(type = factor(type, levels = c("data", "code"))) %>%
  mutate(format = case_when(format == "Other" ~ "other",
                            format == "Unsure" ~ "unsure",
                            TRUE ~ as.character(format)))

# Plot
fig5 <-
  ggplot(summary_all_format, aes(x = forcats::fct_reorder(format, count), y = count)) + 
  geom_col(fill = "lightgrey") +
  theme_bw(base_size = 14) +
  coord_flip() +
  # Remove legend title
  theme(legend.title = element_blank()) +
  xlab("file extension") +
  ylab("files") +
  facet_wrap(~type, scales = "free_x") +
  theme(strip.background = element_rect(fill = "white")) 

# Save figure
ggsave(fig5, file = "figures/fig5_file-extensions.jpg", width = 8, height = 4)

#--------------------------------------------------------------------------------
# 6. Are data/code reusable?
# README + completeness + annotation
#-------------------------------------------------------------------------------
# A. README
#-----------------
# Make a dataframes for plotting
# data
data_readme <- 
  papers %>%
  filter(data_used == "Yes") %>% 
  select(data_README) %>%
  filter(data_README != "Unsure") %>%
  # Change quasi to yes
  mutate(data_README = case_when(data_README == "Quasi-README" ~ "Yes",
                                 TRUE ~ as.character(data_README))) %>%
  group_by(data_README) %>%
  summarise(papers = n()) %>%
  # Exclude NAs
  na.omit() %>%
  # Add a column to id this as for data
  mutate(type = rep("data", n())) %>%
  # rename column so the two datasets match
  rename(README = data_README)

# code
code_readme <- 
  papers %>%
  filter(code_used == "Yes") %>% 
  select(code_README) %>%
  # Change quasi to yes
  mutate(code_README = case_when(code_README == "Quasi-README" ~ "Yes",
                                 TRUE ~ as.character(code_README))) %>%
  group_by(code_README) %>%
  summarise(papers = n()) %>%
  # Exclude NAs
  na.omit() %>%
  # Add a column to id this as for code
  mutate(type = rep("code", n())) %>%
  # rename column so the two datasets match
  rename(README = code_README)

# combine the two
all_readme <-
  rbind(code_readme, data_readme) %>%
  # change levels so plot is in correct order (data first)
  mutate(type = factor(type, levels = c("data", "code")))

# Get totals
all_readme %>% group_by(type) %>% summarise(sum(papers))

# Plot
readme_plot <-
  ggplot(all_readme, aes(x = README, y = papers, fill = README)) + 
  geom_col() +
  coord_flip() +
  theme_bw(base_size = 14) +
  # Remove legend title
  theme(legend.title = element_blank()) +
  xlab("") +
  facet_wrap(~type, scales = "free_x", ncol = 2) +
  theme(strip.background = element_rect(fill = "white")) +
  scale_fill_manual(values = c("#3b2f2f", "#56c8d3")) +
  # Remove legend
  theme(legend.position = "none")

#-----------------
# B. README scales
#-----------------
# data plot
scale_data_plot <- 
  ggplot(papers, aes(x = data_README_scale)) +
  geom_bar(fill = "lightgrey") +
  theme_bw(base_size = 14) +
  xlab("data README scale") +
  scale_x_continuous(breaks = c(1:10)) +
  ylab("papers")

# code plot
scale_code_plot <- 
  ggplot(papers, aes(x = code_README_scale)) +
  geom_bar(fill = "lightgrey") +
  theme_bw(base_size = 14) +
  xlab("code README scale") +
  scale_x_continuous(breaks = c(1:10)) +
  ylab("papers")

#---------------------
# C. Data completeness
#---------------------
# Make dataframe for plot
data_complete <- 
  papers %>%
  filter(data_availability == "Yes") %>% 
  select(data_completeness) %>%
  group_by(data_completeness) %>%
  summarise(papers = n()) %>%
  # Fix levels of factor
  mutate(data_completeness = factor(data_completeness, 
                                    levels = c("Unsure", "Low", "Fair", "High", "Complete"))) %>%
  # Exclude NAs
  na.omit() %>%
  # fix levels
  mutate()

# Plot
complete_data_plot <- 
  ggplot(data_complete, aes(x = data_completeness, y = papers)) +
  geom_col(fill = "lightgrey") +
  theme_bw(base_size = 14) +
  xlab("data completeness") +
  scale_x_discrete(labels = c("Unsure" = "Unsure", "Low" = "1",
                              "Fair" = "2", "High" = "3",
                              "Complete" = "4"))
#-------------------
# D. Code annotation
#-------------------
# Plot
annotate_code_plot <- 
  ggplot(papers, aes(x = code_annotation_scale)) +
  geom_bar(fill = "lightgrey") +
  theme_bw(base_size = 14) +
  xlab("code annotation scale") +
  scale_x_continuous(breaks = c(1:10)) +
  ylab("papers")

#-----------------
# Combine plots
fig6 <- (scale_data_plot + scale_code_plot) / (complete_data_plot+annotate_code_plot) + plot_annotation(tag_levels = "A")

#-----------------
# Get median scores
papers %>% summarise(median(data_README_scale, na.rm = TRUE))
papers %>% summarise(median(code_README_scale, na.rm = TRUE))
papers %>% summarise(median(code_annotation_scale, na.rm = TRUE))

# Save figure
ggsave(fig6, file = "figures/fig6_readme-completeness-annonation.jpg", width = 6, height = 6)

#--------------------------------------------------------------------------------
# 7. What licenses are used?
#---------------------
# data
data_license_type <-
  papers %>% 
  filter(data_used == "Yes" & data_license_type != "No") %>% 
  mutate(data_license_type = case_when(data_license_type == "CC BY derivatives" ~
                                         "other CC BY",
                                       TRUE ~ as.character(data_license_type))) %>%
  select(data_license_type) %>%
  na.omit() %>%
  group_by(data_license_type)  %>%
  summarise(count  = n()) %>%
  # Exclude NAs
  na.omit() %>%
  # Add a column to id this as for code
  mutate(type = rep("data", n())) %>%
  # rename column so the two datasets match
  rename(license_type = data_license_type)

# code
code_license_type <-
  papers %>% 
  filter(code_archived == "Yes" & code_license_type != "Unsure") %>% 
  mutate(code_license_type = case_when(code_license_type == "CC BY derivatives" ~
                                         "other CC BY",
                                       TRUE ~ as.character(code_license_type))) %>%
  select(code_license_type) %>%
  na.omit() %>%
  group_by(code_license_type)  %>%
  summarise(count = n()) %>%
  # Exclude NAs
  na.omit() %>%
  # Add a column to id this as for code
  mutate(type = rep("code", n())) %>%
  # rename column so the two datasets match
  rename(license_type = code_license_type)

# Stick the two summary datasets together
summary_all_lt <-
  rbind(data_license_type, code_license_type) %>%
  # change levels so plot is in correct order (data first)
  mutate(type = factor(type, levels = c("data", "code"))) %>%
  mutate(license_type = case_when(license_type == "Other" ~ "other",
                                   TRUE ~ as.character(license_type)))

# Make the figure
fig7 <-
  ggplot(summary_all_lt, aes(x = forcats::fct_reorder(license_type, count), y = count)) + 
  geom_col(fill = "lightgrey") +
  coord_flip() +
  theme_bw(base_size = 14) +
  # Remove legend title
  theme(legend.title = element_blank()) +
  xlab("") +
  ylab("files") +
  facet_wrap(~type, scales = "free_x") +
  theme(strip.background = element_rect(fill = "white")) +
  expand_limits(y = c(0,300))

# Save figure
ggsave(fig7, file = "figures/fig7_licenses.jpg", width = 6, height = 4)

#-------------------------------------------------------------------------------
# 8. What programming language is code written in?
# Create summary dataset for code language
# Note this was removed from the main text and is now figure S16
#-------------------------------------------------------------------------------
summary_code_language <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(code_language) %>%
  separate_longer_delim(cols = code_language, delim = ";") %>%
  na.omit() %>%
  group_by(code_language) %>%
  summarise(count = n()) %>% 
  arrange(-count) %>%
  mutate(code_language = case_when(code_language == "Other" ~ "other",
                                   TRUE ~ as.character(code_language)))

# Plot
fig_lang <-
  ggplot(summary_code_language, aes(x = forcats::fct_reorder(code_language,count), y = count)) + 
  geom_col(fill = "lightgrey") +
  coord_flip() +
  theme_bw(base_size = 14) +
  # Remove legend title
  theme(legend.title = element_blank()) +
  xlab("programming language") +
  ylab("files")

# Save figure
ggsave(fig_lang, file = "figures/supp-fig_language.png", width = 6, height = 4)