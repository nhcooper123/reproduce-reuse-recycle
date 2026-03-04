# Recorder variability using paper 2272
# Create Figure S15 and results in the supplemental

# Load libraries
library(tidyverse) # for data manipulation and plotting
library(patchwork) # for multi panel plots

# Read in the data for paper 2272 only
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
# Get median scores and SE
check %>% summarise(median = median(data_README_scale, na.rm = TRUE), 
                    se = sqrt(var(data_README_scale, na.rm = TRUE)/length(data_README_scale))) #8
check %>% summarise(median = median(code_README_scale, na.rm = TRUE), 
                    se = sqrt(var(code_README_scale, na.rm = TRUE)/length(code_README_scale))) #4
check %>% summarise(median = median(code_annotation_scale, na.rm = TRUE), 
                    se = sqrt(var(code_annotation_scale, na.rm = TRUE)/length(code_annotation_scale))) #7
# IQ range
summary(check$data_README_scale)
summary(check$code_README_scale)
summary(check$code_annotation_scale)
#--------------------------------------------
# Get numbers with modal score
length(which(check$data_README_scale == 9))
length(which(check$code_README_scale == 3))
length(which(check$code_annotation_scale == 8))

# Mean agreement
x <- c(rep(100, 24), 96, 31, 86, 99, 99, 98, 88, 87, 88, 17, 22)
mean(x)
sqrt(var(x)/length(x))

# Excluding scaled variables
x1 <- c(rep(100, 24), 96, 86, 99, 99, 98, 88, 87, 88)
mean(x1)
sqrt(var(x1)/length(x1))

# Save figure
ggsave(variability_figs, file = "figures/supp-fig_recorder-variability.jpg", width = 6, height = 6)
