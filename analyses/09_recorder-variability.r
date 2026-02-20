# Recorder variability
# 
# Load libraries
library(tidyverse)
library(patchwork)

# Read in the data
check <- read_csv("data/data-validation_2025-11-16.csv")

#--------------------------------------
# How variable are data recorders?
#------------------------------------------
# README scales + completeness + annotation
#-------------------------------------------------------------------------------
# A. README scales
#-----------------
# data plot
scale_data_plot <- 
  ggplot(check, aes(x = data_README_scale)) +
  geom_bar(fill = "lightgrey") +
  theme_bw(base_size = 14) +
  xlab("data README scale") +
  ylab("recorders") +
  scale_x_continuous(breaks = 1:10)

# code plot
scale_code_plot <- 
  ggplot(check, aes(x = code_README_scale)) +
  geom_bar(fill = "lightgrey") +
  theme_bw(base_size = 14) +
  xlab("code README scale") +
  ylab("recorders") +
  scale_x_continuous(breaks = c(1:10))

#---------------------
# B. Data completeness
#---------------------
# Make dataframe for plot
data_complete <- 
  check %>%
  filter(data_availability == "Yes") %>% 
  select(data_completeness) %>%
  group_by(data_completeness) %>%
  summarise(papers = n()) %>%
  # Fix level of factor
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
                              "Complete" = "4")) +
  ylab("recorders") 
#-------------------
# C. Code annotation
#-------------------
# Plot
annotate_code_plot <- 
  ggplot(check, aes(x = code_annotation_scale)) +
  geom_bar(fill = "lightgrey") +
  theme_bw(base_size = 14) +
  xlab("code annotation scale") +
  ylab("recorders") +
  scale_x_continuous(breaks = c(1:10))

#-----------------
# Combine plots
variability_figs <- (scale_data_plot + scale_code_plot) / (complete_data_plot+annotate_code_plot) + plot_annotation(tag_levels = "A")

#-----------------
# Get median scores
check %>% summarise(median(data_README_scale, na.rm = TRUE))
check %>% summarise(median(code_README_scale, na.rm = TRUE))
check %>% summarise(median(code_annotation_scale, na.rm = TRUE))

# Save figure
ggsave(variability_figs, file = "figures/supp-fig_recorder-variability.jpg", width = 6, height = 6)
