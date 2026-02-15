# README quality analyses
# 
# Load libraries
library(tidyverse)

# Read in the data
papers <- read_csv("data/BES-data-code-hackathon-cleaned_2025-11-16.csv")

#--------------------------------------
# Is README quality related to archive?
#--------------------------------------
# Extract just variables needed.
readme <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(data_archive, data_README, data_README_scale) %>%
  separate_longer_delim(cols = data_archive, delim = ";") %>%
  na.omit() %>%
  mutate(data_archive = case_when(data_archive == "GitHub, GitLab, Codeberg or similar platform" 
                                                  ~ "GitHub, GitLab, Codeberg etc.",
                                  TRUE ~ as.character(data_archive)))

# Calculate means and SE
readme_summary <- 
  readme %>%
  group_by(data_archive) %>%
  summarise(median = median(data_README_scale),
            SE = sqrt(var(data_README_scale)/n()))
  
# Plot 
readme_archive_fig <-
ggplot(readme, aes(x = data_README_scale)) +
  geom_bar() +
  facet_wrap(~data_archive, scales = "free_y") +
  theme_bw(base_size = 14) +
  xlab("README scale") +
  ylab("") +
  scale_x_continuous(breaks = c(1:10)) +
  theme(strip.background = element_rect(fill = "white"))

# Save figure
ggsave(readme_archive_fig, file = "figures/supp-fig_README-by-archive.jpg", width = 10, height = 5)

# Are READMEs significantly better in certain archives?
x <- lm(data_README_scale ~ data_archive, data = readme)
plot(x)
anova(x)
summary(x)
