# Fix recorders and provide a unique ID to each unique recorder or set of recorders
# ---------------
# Load libraries
# ---------------
library(tidyverse)
library(janitor)
library(naniar)

# ------------------
# Read in the data
# ------------------
# Read in raw data
rawdata <- read_csv("raw-data/non-anonymised-data/BES-data-code-hackathon-raw-outputs.csv")

# Change name for recorder column to make manipulation easier
rawdata <-
  rawdata %>%
  rename(recorder = `1. Who recorded data from this paper? First name and initials only for GDPR reasons. If working in pairs, record both names separated by a comma.`) 

# Exclude recorder names from the first 127 rows which are from test run prior to 12 noon 30th Sept
rawdata$recorder[1:127] <- NA_character_

# Update all recorders to omit accidental repeats caused by people misspelling their names
rawdata <-
  rawdata %>%
  mutate(recorder = case_when(recorder == "Amy A.D" ~ "Amy AD",
                              recorder == "Angel AP, Albert AM" ~ "Albert AM, Angel AP",
                              recorder == "Anna AX" ~  "Anna AC",
                              recorder == "Becky S Angelena E" ~ "Becky S, Angelena E",
                              recorder == "Claire CLN; Robert RAB; Richard RR" ~ "Claire CLN, Robert RAB, Richard RR",
                              recorder == "Daan M." ~ "Daan M",
                              recorder == "Divya A" ~ "Divya DA" ,
                              recorder == "Elizabeth A. B." ~ "Elizabeth A.B.",
                              recorder == "Elvira D'Bastiani" ~ "Elvira DB.",
                              recorder == "Fernando FGT" ~ "Fernando GT",
                              recorder == "Gabriel SS" ~ "Gabriel GS" ,
                              recorder ==  "Gabriel, GS" ~ "Gabriel GS" ,
                              recorder == "Gideon D." ~ "Gideon D",
                              recorder == "Gideon G. Deme" ~ "Gideon D",
                              recorder == "G Iossa" ~ "Graziella I" ,
                              recorder == "Helen HP, Kaushalya KN, Rebekka RK, Sylvain SG" |
                                recorder == "Rebekka RK, Helen HP, Kaushakya KN, Sylvain SG" |      
                                recorder == "Rebekka RK, Helen HP, Kaushalya KN, Sylvain SG"|       
                                recorder == "Rebekka RK, Helen HP, Sylvain SG, Kaushalya KN" |
                                recorder == "Sylvain SG, Kaushalya KN, Rebekka RK, Helen HP" |      
                                recorder == "Sylvain SG, Rebekka RK, Kaushalya KN, Helen HP" ~ "Helen HP, Rebekka RN, Sylvain SG, Kaushalya KN", 
                              recorder == "Joanthan JFJ" ~ "Jonathan JFJ", 
                              recorder == "Lucia Šmídova" ~ "Lucia Šmídová",
                              recorder == "LUIS LMMT" ~ "Luis LMMT", 
                              recorder == "Manuel A Duenas" | recorder == "Manuel A. D."  |                                       
                                recorder == "Manuel A. Duenas" |  recorder == "Manuel A.D." ~ "Manuel AD",
                              recorder == "Maria Elizabeth Barbosa de Sousa / Maria Elizabeth BS" |
                                recorder == "Maria Elizabeth Barbosa de Sousa/ Maria Elizabeth BS" ~ "Maria Elizabeth Barbosa de Sousa", 
                              recorder == "MatthewMRK" ~ "Matthew MRK",
                              recorder == "Myrna E. F. S." ~ "Myrna E F S",
                              recorder == "Nabilla NNK, Bethan H" ~ "Bethan H, Nabilla NNK",
                              recorder == "Nour A." ~ "Nour NA",
                              recorder == "Oliwia K." ~ "Oliwia K", 
                              recorder == "PietroP" ~ "Pietro PP" ,
                              recorder == "sara c" ~ "Sara C" ,
                              recorder == "Sonia SI" ~ "Sonia SIC", 
                              recorder == "VictoriaG, RochelleK" ~ "Victoria G, Rochelle K", 
                              recorder == "Viktoria T, Chirstian D" ~ "Viktoria T, Christian D",
                              TRUE ~ as.character(recorder)))

# Give each recorder or set of recorders a unique ID
# Then remove the recorder column
rawdata <- 
  rawdata %>%                                      
  group_by(recorder) %>%
  mutate(recorder_ID = cur_group_id()) %>%
  ungroup() %>%
  select(-recorder)

# Write to file
write_csv(rawdata, "raw-data/BES-data-code-hackathon-raw-outputs_ANON.csv")


