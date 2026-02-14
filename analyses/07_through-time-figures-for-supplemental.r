# Through time figures for the supplemental

# Load libraries
library(tidyverse)
library(patchwork)

# Build colour scheme for the journals
journal_cols <- c("#A2DACC", # ESE
                  "#EDC04E", # Functional Ecology
                  "#45B599", # J Applied Ecology
                  "#AC92ED", # J Animal Ecology
                  "#AECEF6", # J Ecology
                  "#e3626f", # MEE
                  "#DDAC93") # People and Nature

# Read in the data
papers <- read_csv("data/BES-data-code-hackathon-cleaned_2025-12-01.csv")

#--------------------------------------
# How have things changed through time?
#--------------------------------------
# DATA
#--------------------------------------
# Create a long dataframe for plotting
time_data <- 
  papers %>%
  # Select just variables of interest
  select(year_published, data_used, data_availability, data_link, data_download,
         data_open, data_doi, data_license, data_README) %>%
  # Recode as appropriate to clean options up a bit
  mutate(data_availability = case_when(data_availability == "No, but they are available on request" ~ "No",
                                       TRUE ~ as.character(data_availability))) %>%
  mutate(data_download = case_when(data_download == "No, because the data are embargoed" ~ "No",
                                   data_download == "Yes, but not all data" ~ "Yes",
                                   TRUE ~ as.character(data_download))) %>%
  mutate(data_open = case_when(data_open == "Needs specific software or too large" ~ "Maybe",
                               data_open == "Yes, but not all files" ~ "Yes",
                               TRUE ~ as.character(data_open))) %>%
  mutate(data_README = case_when(data_README == "Quasi-README" ~ "Yes",
                              TRUE ~ as.character(data_README))) %>%
  mutate(data_doi = case_when(data_doi == "Yes, but not for all data archived" ~ "Yes",
                              data_doi == "Yes, but DOI not found/incorrect" ~ "No",
                              TRUE ~ as.character(data_doi))) %>%
  mutate(data_license = case_when(data_license == "Yes, but not for all data archived" ~ "Yes",
                                  TRUE ~ as.character(data_license))) %>%
  # Reshape to make columns into rows 
  pivot_longer(c(data_used:data_README), names_to = "var") %>%
  # change the names so they look better on the plots
  mutate(var = case_when(var == "data_used" ~ "used",
                         var == "data_availability" ~ "archived",
                         var == "data_link" ~ "link",
                         var == "data_download" ~ "download",
                         var == "data_open" ~ "open",
                         var == "data_README" ~ "README",
                         var == "data_doi" ~ "doi",
                         var == "data_license" ~ "license")) %>%
  # Exclude NAs
  na.omit() %>%
  # Order levels of value
  mutate(value = factor(value, levels = c("No", "Maybe", "Yes"))) %>%
  # reorder the factors so the order is correct in the plot
  mutate(var = factor(var, levels = c("used", "archived", "link",
                                      "download", "open", "README",
                                      "doi", "license")))

# Plot
time_data_fig <- 
  ggplot(time_data, aes(x = year_published, fill = value)) + 
  geom_bar(position = "fill") + 
    scale_fill_manual(values = c("#3b2f2f", "#f9cf57","#56c8d3")) +
    theme_bw() +
    theme(legend.position = "none") +
    scale_x_continuous(breaks = c(2017:2024), labels = 2017:2024) +
    xlab("") +
    ylab("proportion") +
    facet_wrap(~var) +
    theme(strip.background = element_rect(fill = "white"))
  
# Save figure
ggsave(time_data_fig, file = "figures/supp-fig_data-through-time.jpg", width = 10, height = 5)

#--------------------------------------
# CODE
#--------------------------------------
# Create a long dataframe for plotting
time_code <- 
  papers %>%
  # Select just variables of interest
  select(year_published, code_used, code_availability, code_link, code_download,
         code_open, code_doi, code_license, code_README) %>%
  # Recode as appropriate to clean options up a bit
  mutate(code_open = case_when(code_open == "Maybe if I had the right software" ~ "Maybe",
                               TRUE ~ as.character(code_open))) %>%
  mutate(code_doi = case_when(code_doi == "Yes, same as data" ~ "Yes",
                              TRUE ~ as.character(code_doi))) %>%
  # Reshape to make columns into rows 
  pivot_longer(c(code_used:code_README), names_to = "var") %>%
  # change the names so they look better on the plots
  mutate(var = case_when(var == "code_used" ~ "used",
                         var == "code_availability" ~ "archived",
                         var == "code_link" ~ "link",
                         var == "code_download" ~ "download",
                         var == "code_open" ~ "open",
                         var == "code_README" ~ "README",
                         var == "code_doi" ~ "doi",
                         var == "code_license" ~ "license")) %>%
  # Exclude NAs
  na.omit() %>%
  # Order levels of value
  mutate(value = factor(value, levels = c("No", "Maybe", "Yes"))) %>%
  # reorder the factors so the order is correct in the plot
  mutate(var = factor(var, levels = c("used", "archived", "link",
                                      "download", "open", "README",
                                      "doi", "license")))

# Plot
time_code_fig <- 
  ggplot(time_code, aes(x = year_published, fill = value)) + 
  geom_bar(position = "fill") + 
  scale_fill_manual(values = c("#3b2f2f", "#f9cf57","#56c8d3")) +
  theme_bw() +
  theme(legend.position = "none") +
  scale_x_continuous(breaks = c(2017:2024), labels = 2017:2024) +
  xlab("") +
  ylab("proportion") +
  facet_wrap(~var) +
  theme(strip.background = element_rect(fill = "white"))

# Save figure
ggsave(time_code_fig, file = "figures/supp-fig_code-through-time.jpg", width = 10, height = 5)
