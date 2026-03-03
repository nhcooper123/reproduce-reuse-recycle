# Figures by journal for supplemental

# Load libraries
library(tidyverse)
library(patchwork)

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

remove_x <- theme(axis.title.x=element_blank(),
                  axis.text.x=element_blank(),
                  axis.ticks.x=element_blank())

remove_y <- theme(axis.title.y=element_blank(),
                  axis.text.y=element_blank(),
                  axis.ticks.y=element_blank())
#-------------------------------------------------------------------------------
# Recode as appropriate to clean options up a bit
#------------------------------------------------------------------------------
papers <-
  papers %>%
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
  mutate(code_open = case_when(code_open == "Maybe if I had the right software" ~ "Maybe",
                               TRUE ~ as.character(code_open))) %>%
  mutate(code_doi = case_when(code_doi == "Yes, same as data" ~ "Yes",
                              TRUE ~ as.character(code_doi)))

#------------------------------------------------------------------------------
# 1. Papers per year
#--------------------
# Summarise papers per year per journal
paper_summary <-
  papers %>%
  group_by(journal, year_published) %>%
  summarise(count = n())

# Plot
ggplot(paper_summary, aes(x = year_published, y = count, fill = journal)) +
  geom_col() +
  theme_bw(base_size = 14) +
  scale_fill_manual(values = journal_cols) +
  theme(legend.position = "none") +
  facet_wrap(~ journal) +
  theme(strip.background = element_rect(colour = "black", fill = "white"), 
        strip.text.x = element_text(size = 9)) +
  xlab("year published") +
  scale_x_continuous(breaks = 2017:2024) +
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5))

# Save figure
ggsave(file = "figures/supp-fig_journals-year.png", width = 8, height = 6)

#-------------------------------------------------------------------------------
# 2. How many papers have data?
#------------------------------
data_by_journal <- 
  papers %>% 
  group_by(journal, data_used)

A <- 
  ggplot(data_by_journal, aes(x = journal, fill = data_used)) + 
  geom_bar(position = "fill") + 
  coord_flip() + 
  scale_fill_manual(values = c("#3b2f2f", "#56c8d3")) +
  theme_bw(base_size = 14) +
  theme(legend.position = "none") +
  remove_x

#-------------------------------------------------------------------------------
# 3. Is the data mentioned in the Data Availability statement?
#--------------------------------------------------------------
data_avail_by_journal <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(journal, data_availability)

B <- 
  ggplot(data_avail_by_journal, aes(x = journal, fill = data_availability)) + 
  geom_bar(position = "fill") + 
  scale_fill_manual(values = c("#3b2f2f", "#56c8d3")) +
  coord_flip() + 
  theme_bw(base_size = 14) +
  theme(legend.position = "none") +
  remove_y +
  remove_x

#--------------------------------------------------------------
# 4. Where are the data archived?
#--------------------------------------------------------------
data_archive_by_journal <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(journal, data_archive) %>% 
  na.omit() %>%
  separate_longer_delim(cols = data_archive, delim = ";") %>%
  group_by(journal, data_archive) %>%
  summarise(count = n())

# split by journal
ggplot(data_archive_by_journal, aes(x = data_archive, y = count, fill = journal)) + 
  geom_col() + 
  theme_bw(base_size = 14) +
  # Remove legend title
  theme(legend.title = element_blank()) +
  scale_fill_manual(values = journal_cols) +
  facet_wrap(~journal, scales = "free_y") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(angle = 45, size = 6, hjust = 0.8)) +
  theme(strip.background = element_rect(colour = "black", fill = "white"), 
        strip.text.x = element_text(size = 9)) +
  xlab("data archive") +
  scale_x_discrete(labels = c("Dryad", "Figshare", "GitHub etc", "Other", "Website", "Supp mat", "Zenodo"))

# Save figure
ggsave(file = "figures/supp-fig_journals-data-archive.png", width = 8, height = 6)

#--------------------------------------------------------------
# 5. Can the data be accessed via the link?
#--------------------------------------------------------------
data_link_by_journal <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(journal, data_link) %>% 
  na.omit()

C <- 
  ggplot(data_link_by_journal, aes(x = journal, fill = data_link)) + 
  geom_bar(position = "fill") + 
  scale_fill_manual(values = c("#3b2f2f", "#56c8d3")) +
  coord_flip() + 
  theme_bw(base_size = 14) +
  theme(legend.position = "none") +
  remove_x

#--------------------------------------------------------------
# 6. Can the data be downloaded?
#--------------------------------------------------------------
data_download_by_journal <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(journal, data_download) %>% 
  mutate(data_download = factor(data_download, levels = c("No", "No, because the data are embargoed",
                                                          "Yes, but not all data", "Yes" ))) %>%
  na.omit()

D <- 
  ggplot(data_download_by_journal, aes(x = journal, fill = data_download)) + 
  geom_bar(position = "fill") + 
  scale_fill_manual(values = c("#3b2f2f", "#56c8d3")) +
  coord_flip() + 
  theme_bw(base_size = 14) +
  theme(legend.position = "none") +
  remove_y +
  remove_x

#--------------------------------------------------------------
# 7. Can the data be opened?
#--------------------------------------------------------------
data_open_by_journal <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(journal, data_open) %>% 
  mutate(data_open = factor(data_open, levels = c("No", "Needs specific software or too large",
                                                  "Yes, but not all files", "Yes" ))) %>%
  na.omit()

E <- 
  ggplot(data_open_by_journal, aes(x = journal, fill = data_open)) + 
  geom_bar(position = "fill") + 
  scale_fill_manual(values = c( "#3b2f2f", "#56c8d3")) +
  coord_flip() + 
  theme_bw(base_size = 14) +
  theme(legend.position = "none") +
  remove_x

#--------------------------------------------------------------
# 8. What file extensions are the data stored in?
#--------------------------------------------------------------

# Top data 10 file extensions
summary_data_format <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(journal, data_format) %>%
  separate_longer_delim(cols = data_format, delim = ";") %>%
  na.omit() %>%
  group_by(journal, data_format) %>%
  summarise(count = n()) %>% 
  arrange(-count) %>% 
  slice(1:10)

ggplot(summary_data_format, aes(x = data_format, y = count, fill = journal)) +
  geom_col() +
  facet_wrap(~journal, scales = "free_y") +
  theme_bw(base_size = 14) +
  theme(strip.background = element_rect(colour = "black", fill = "white"), 
        strip.text.x = element_text(size = 9)) +
  xlab("data file extension") +
  scale_fill_manual(values = journal_cols) +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(angle = 45, size = 6, hjust = 0.8))

# Save figure
ggsave(file = "figures/supp-fig_journals-data-file-extension.png", width = 8, height = 6)

#--------------------------------------------------------------
# 9. Does the data have a readme?
#--------------------------------------------------------------
data_readme_by_journal <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(journal, data_README) %>%
  na.omit()

F <- 
  ggplot(data_readme_by_journal, aes(x = journal, fill = data_README)) + 
  geom_bar(position = "fill") + 
  scale_fill_manual(values = c( "#3b2f2f","#f9cf57", "#56c8d3")) +
  coord_flip() + 
  theme_bw(base_size = 14) +
  theme(legend.position = "none") +
  remove_y +
  remove_x

#--------------------------------------------------------------
# 10. How useful is the readme?
#--------------------------------------------------------------
data_readme_scale_by_journal <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(journal, data_README_scale) %>%
  na.omit()

ggplot(data_readme_scale_by_journal, aes(x = data_README_scale, fill = journal)) + 
  geom_bar() + 
  theme_bw(base_size = 14) +
  # Remove legend
  theme(legend.position = "none") +
  scale_fill_manual(values = journal_cols) +
  theme(strip.background = element_rect(colour = "black", fill = "white"), 
        strip.text.x = element_text(size = 9)) +
  facet_wrap(~journal, scales = "free_y") +
  xlab("data README quality") +
  scale_x_continuous(breaks = 1:10)

# Save figure
ggsave(file = "figures/supp-fig_journals-data-readme-quality.png", width = 8, height = 6)

# Average usefulness of README
data_readme_scale_by_journal %>% 
  group_by(journal) %>% 
  summarise(`Average README usefulness` = median(data_README_scale, na.rm = TRUE))

#--------------------------------------------------------------
# 11. How complete are the archived data?
#--------------------------------------------------------------
data_completeness_by_journal <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(journal, data_completeness) %>% 
  mutate(data_completeness = factor(data_completeness, levels = c("Unsure", "Low", "Fair", 
                                                                  "High", "Complete"))) %>%
  na.omit() 

ggplot(data_completeness_by_journal, aes(x = data_completeness, fill = journal)) + 
  geom_bar() + 
  theme_bw(base_size = 14) +
  # Remove legend
  theme(legend.position = "none") +
  scale_fill_manual(values = journal_cols) +
  theme(strip.background = element_rect(colour = "black", fill = "white"), 
        strip.text.x = element_text(size = 9)) +
  facet_wrap(~journal, scales = "free_y") +
  xlab("data completeness")

# Save figure
ggsave(file = "figures/supp-fig_journals-data-completeness.png", width = 8, height = 6)

#--------------------------------------------------------------
# 12. Does the data have a DOI?
#--------------------------------------------------------------
data_doi_by_journal <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(journal, data_doi) %>% 
  na.omit() 

G <- 
  ggplot(data_doi_by_journal, aes(x = journal, fill = data_doi)) + 
  geom_bar(position = "fill") + 
  coord_flip() + 
  theme_bw(base_size = 14) +
  # Remove legend title
  theme(legend.title = element_blank()) +
  ylab("proportion") +
  theme(legend.position = "none") +
  scale_fill_manual(values = c( "#3b2f2f","#f9cf57", "#56c8d3"))

#--------------------------------------------------------------
# 13. Does the data have a license?
#--------------------------------------------------------------
data_license_by_journal <- 
  papers %>% 
  filter(data_used == "Yes") %>% 
  select(journal, data_license) %>% 
  mutate(data_license = factor(data_license, levels = c("No", "Unsure", "Yes, but not for all data archived", "Yes"))) %>%
  na.omit() 

H <- 
  ggplot(data_license_by_journal, aes(x = journal, fill = data_license)) + 
  geom_bar(position = "fill") + 
  scale_fill_manual(values = c( "#3b2f2f", "#f9cf57", "#56c8d3")) +
  coord_flip() + 
  theme_bw(base_size = 14) +
  ylab("proportion") +
  # Remove legend title
  theme(legend.title = element_blank()) +
  remove_y

#--------------------------------------------------------------
# 14. If it does have a license what type?
#--------------------------------------------------------------
data_license_type_by_journal <- 
  papers %>% 
  filter(data_used == "Yes" & data_license_type != "No") %>% 
  select(journal, data_license_type) %>% 
  mutate(data_license_type = case_when(data_license_type == "CC BY derivatives" ~ "Other CC BY",
                                       TRUE ~ as.character(data_license_type))) %>%
  na.omit() 

ggplot(data_license_type_by_journal, aes(fill = journal, x = data_license_type)) + 
  geom_bar() + 
  theme_bw(base_size = 14) +
  # Remove legend
  theme(legend.position = "none") +
  scale_fill_manual(values = journal_cols) +
  theme(strip.background = element_rect(colour = "black", fill = "white"), 
        strip.text.x = element_text(size = 9)) +
  facet_wrap(~journal, scales = "free_y") +
  xlab("data license") +
  theme(axis.text.x = element_text(angle = 45, size = 8, hjust = 0.8, ))

# Save figure
ggsave(file = "figures/supp-fig_journals-data-license.png", width = 8, height = 6)

#--------------------------------------------------------------
# Combine plots
#--------------------------------------------------------------

(A + B) / (C + D) / (E + F) + (G + H) + plot_annotation(tag_levels = "A")

# Save figure
ggsave(file = "figures/supp-fig_journals-data-variables.png", width = 8, height = 8)

#------------------------------
# CODE
#------------------------------------------------------------------------------
# 2. How many papers have code?
#------------------------------
code_by_journal <- 
  papers %>% 
  group_by(journal, code_used)

A1 <- 
  ggplot(code_by_journal, aes(x = journal, fill = code_used)) + 
  geom_bar(position = "fill") + 
  coord_flip() + 
  scale_fill_manual(values = c("#3b2f2f", "#f9cf57", "#56c8d3")) +
  theme_bw(base_size = 14) +
  theme(legend.position = "none") +
  remove_x

#-------------------------------------------------------------------------------
# 3. Is the code mentioned in the Data Availability statement?
#--------------------------------------------------------------
code_avail_by_journal <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(journal, code_availability) %>%
  na.omit()

B1 <- 
  ggplot(code_avail_by_journal, aes(x = journal, fill = code_availability)) + 
  geom_bar(position = "fill") + 
  scale_fill_manual(values = c("#3b2f2f", "#56c8d3")) +
  coord_flip() + 
  theme_bw(base_size = 14) +
  theme(legend.position = "none") +
  remove_y +
  remove_x
#--------------------------------------------------------------
# 4. Where are the code archived?
#--------------------------------------------------------------
code_archive_by_journal <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(journal, code_archive) %>% 
  na.omit() %>%
  separate_longer_delim(cols = code_archive, delim = ";") %>%
  group_by(journal, code_archive) %>%
  summarise(count = n())

# split by journal
ggplot(code_archive_by_journal, aes(x = code_archive, y = count, fill = journal)) + 
  geom_col() + 
  theme_bw(base_size = 14) +
  # Remove legend title
  theme(legend.title = element_blank()) +
  scale_fill_manual(values = journal_cols) +
  facet_wrap(~journal, scales = "free_y") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(angle = 45, size = 6, hjust = 0.8)) +
  theme(strip.background = element_rect(colour = "black", fill = "white"), 
        strip.text.x = element_text(size = 9)) +
  xlab("code archive") +
  scale_x_discrete(labels = c("Dryad", "Figshare", "GitHub etc", "Other", "Website", "Supp mat", "Zenodo"))

# Save figure
ggsave(file = "figures/supp-fig_journals-code-archive.png", width = 8, height = 6)
  
#--------------------------------------------------------------
# 5. Can the code be accessed via the link?
#--------------------------------------------------------------
code_link_by_journal <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(journal, code_link) %>% 
  na.omit()

C1 <- 
  ggplot(code_link_by_journal, aes(x = journal, fill = code_link)) + 
  geom_bar(position = "fill") + 
  scale_fill_manual(values = c("#3b2f2f", "#56c8d3")) +
  coord_flip() + 
  theme_bw(base_size = 14) +
  theme(legend.position = "none") +
  remove_x

#--------------------------------------------------------------
# 6. Can the code be downloaded?
#--------------------------------------------------------------
code_download_by_journal <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(journal, code_download) %>% 
  mutate(code_download = factor(code_download, levels = c("No", "No, because the code are embargoed",
                                                          "Yes, but not all code", "Yes" ))) %>%
  na.omit()

D1 <- 
  ggplot(code_download_by_journal, aes(x = journal, fill = code_download)) + 
  geom_bar(position = "fill") + 
  scale_fill_manual(values = c("#3b2f2f", "#56c8d3")) +
  coord_flip() + 
  theme_bw(base_size = 14) +
  theme(legend.position = "none") +
  remove_y +
  remove_x

#--------------------------------------------------------------
# 7. Can the code be opened?
#--------------------------------------------------------------
code_open_by_journal <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(journal, code_open) %>% 
  mutate(code_open = factor(code_open, levels = c("No", "Needs specific software or too large",
                                                  "Yes, but not all files", "Yes" ))) %>%
  na.omit()

E1 <- 
  ggplot(code_open_by_journal, aes(x = journal, fill = code_open)) + 
  geom_bar(position = "fill") + 
  scale_fill_manual(values = c( "#3b2f2f", "#56c8d3")) +
  coord_flip() + 
  theme_bw(base_size = 14) +
  theme(legend.position = "none") +
  remove_x

#--------------------------------------------------------------
# 8. What file extensions are the code stored in?
#--------------------------------------------------------------

# Top code 10 file extensions
summary_code_format <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(journal, code_format) %>%
  separate_longer_delim(cols = code_format, delim = ";") %>%
  na.omit() %>%
  group_by(journal, code_format) %>%
  summarise(count = n()) %>% 
  arrange(-count) %>% 
  slice(1:10)

ggplot(summary_code_format, aes(x = code_format, y = count, fill = journal)) +
 geom_col() +
  facet_wrap(~journal, scales = "free_y") +
  theme_bw(base_size = 14) +
  theme(strip.background = element_rect(colour = "black", fill = "white"), 
        strip.text.x = element_text(size = 9)) +
  xlab("code file extension") +
  scale_fill_manual(values = journal_cols) +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(angle = 45, size = 6, hjust = 0.8, ))

# Save figure
ggsave(file = "figures/supp-fig_journals-code-file-extension.png", width = 8, height = 6)

#--------------------------------------------------------------
# 9. Does the code have a readme?
#--------------------------------------------------------------
code_readme_by_journal <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(journal, code_README) %>%
  mutate(code_README = case_when(code_README == "Quasi-README" ~ "Yes",
                                 TRUE ~ as.character(code_README))) %>%
  na.omit()

F1 <- 
  ggplot(code_readme_by_journal, aes(x = journal, fill = code_README)) + 
  geom_bar(position = "fill") + 
  scale_fill_manual(values = c( "#3b2f2f", "#56c8d3")) +
  coord_flip() + 
  theme_bw(base_size = 14) +
  theme(legend.position = "none") +
  remove_y +
  remove_x

#--------------------------------------------------------------
# 10. How useful is the readme?
#--------------------------------------------------------------
code_readme_scale_by_journal <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(journal, code_README_scale) %>%
  na.omit()

ggplot(code_readme_scale_by_journal, aes(x = code_README_scale, fill = journal)) + 
  geom_bar() + 
  theme_bw(base_size = 14) +
  # Remove legend
  theme(legend.position = "none") +
  scale_fill_manual(values = journal_cols) +
  theme(strip.background = element_rect(colour = "black", fill = "white"), 
        strip.text.x = element_text(size = 9)) +
  facet_wrap(~journal, scales = "free_y") +
  xlab("code README quality") +
  scale_x_continuous(breaks = 1:10)

# Save figure
ggsave(file = "figures/supp-fig_journals-code-readme-quality.png", width = 8, height = 6)

# Average usefulness of README
code_readme_scale_by_journal %>% 
  group_by(journal) %>% 
  summarise(`Average README usefulness` = median(code_README_scale, na.rm = TRUE))

#--------------------------------------------------------------
# 11. How well annotated are the archived code?
#--------------------------------------------------------------
code_annotation_by_journal <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(journal, code_annotation_scale) %>%
  na.omit()

ggplot(code_annotation_by_journal, aes(x = code_annotation_scale, fill = journal)) + 
  geom_bar() + 
  geom_bar() + 
  theme_bw(base_size = 14) +
  # Remove legend
  theme(legend.position = "none") +
  scale_fill_manual(values = journal_cols) +
  theme(strip.background = element_rect(colour = "black", fill = "white"), 
        strip.text.x = element_text(size = 9)) +
  facet_wrap(~journal, scales = "free_y") +
  xlab("code annotation") +
  scale_x_continuous(breaks = 1:10)

# Save figure
ggsave(file = "figures/supp-fig_journals-code-annotation.png", width = 8, height = 6)

# Average completeness of annotation
code_annotation_by_journal %>% 
  group_by(journal) %>% 
  summarise(`Average annotation` = median(code_annotation_scale, na.rm = TRUE)) %>% 
  arrange(-`Average annotation`) 
#--------------------------------------------------------------
# 12. Does the code have a DOI?
#--------------------------------------------------------------
code_doi_by_journal <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(journal, code_doi) %>% 
  na.omit() 

G1 <- 
  ggplot(code_doi_by_journal, aes(x = journal, fill = code_doi)) + 
  geom_bar(position = "fill") + 
  coord_flip() + 
  theme_bw(base_size = 14) +
  # Remove legend title
  theme(legend.title = element_blank()) +
  ylab("proportion") +
  theme(legend.position = "none") +
  scale_fill_manual(values = c( "#3b2f2f","#f9cf57", "#56c8d3"))

#--------------------------------------------------------------
# 13. Does the code have a license?
#--------------------------------------------------------------
code_license_by_journal <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(journal, code_license) %>% 
  mutate(code_license = factor(code_license, levels = c("No", "Unsure", "Yes, but not for all code archived", "Yes"))) %>%
  na.omit() 

H1 <- 
  ggplot(code_license_by_journal, aes(x = journal, fill = code_license)) + 
  geom_bar(position = "fill") + 
  scale_fill_manual(values = c( "#3b2f2f", "#f9cf57", "#56c8d3")) +
  coord_flip() + 
  theme_bw(base_size = 14) +
  ylab("proportion") +
  # Remove legend title
  theme(legend.title = element_blank()) +
  remove_y

#--------------------------------------------------------------
# 14. If it does have a license what type?
#--------------------------------------------------------------
code_license_type_by_journal <- 
  papers %>% 
  filter(code_used == "Yes" & code_license_type != "No") %>% 
  select(journal, code_license_type) %>% 
  mutate(code_license_type = case_when(code_license_type == "CC BY derivatives" ~ "Other CC BY",
                                  TRUE ~ as.character(code_license_type))) %>%
  na.omit() 

ggplot(code_license_type_by_journal, aes(fill = journal, x = code_license_type)) + 
  geom_bar() + 
  theme_bw(base_size = 14) +
  # Remove legend
  theme(legend.position = "none") +
  scale_fill_manual(values = journal_cols) +
  theme(strip.background = element_rect(colour = "black", fill = "white"), 
        strip.text.x = element_text(size = 9)) +
  facet_wrap(~journal, scales = "free_y") +
  xlab("code license") +
  theme(axis.text.x = element_text(angle = 45, size = 8, hjust = 0.8))

# Save figure
ggsave(file = "figures/supp-fig_journals-code-license.png", width = 8, height = 6)


#--------------------------------------------------------------
# 15. What language is the code in?

# Top code 10 languages
summary_code_language <- 
  papers %>% 
  filter(code_used == "Yes") %>% 
  select(journal, code_language) %>%
  separate_longer_delim(cols = code_language, delim = ";") %>%
  na.omit() %>%
  group_by(journal, code_language) %>%
  summarise(count = n()) %>% 
  arrange(-count) %>% 
  slice(1:10)

ggplot(summary_code_language, aes(fill = journal, x = code_language, y = count)) + 
  geom_col() + 
  theme_bw(base_size = 14) +
  # Remove legend
  theme(legend.position = "none") +
  scale_fill_manual(values = journal_cols) +
  theme(strip.background = element_rect(colour = "black", fill = "white"), 
        strip.text.x = element_text(size = 9)) +
  facet_wrap(~journal, scales = "free_y") +
  xlab("programming language") +
  theme(axis.text.x = element_text(angle = 45, size = 8, hjust = 0.8))

# Save figure
ggsave(file = "figures/supp-fig_journals-code-language.png", width = 8, height = 6)

#--------------------------------------------------------------
# Combine plots
#--------------------------------------------------------------

(A1 + B1) / (C1 + D1) / (E1 + F1) + (G1 + H1) + plot_annotation(tag_levels = "A")

# Save figure
ggsave(file = "figures/supp-fig_journals-code-variables.png", width = 8, height = 8)

#--------------------------------------------------------------