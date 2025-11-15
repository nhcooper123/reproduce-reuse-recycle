# Initial data cleaning
# NC. Nov 2025

# Prior to running this code I ran a script that tidied and anonymised the recorders. 
# Each unique recorder or set of recorders has a unique recorder_ID number. recorder_ID 151 is NA.
# No other changes were made to the raw data.

# This script takes that raw data and (slowly and painfully) cleans it so it can be used in the analyses.
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
rawdata <- read_csv("raw-data/BES-data-code-hackathon-raw-outputs_ANON.csv")

# Exclude 127 rows from test run prior to 12 noon 30th Sept
rawdata <- 
  rawdata %>%
  slice(-(1:127))

# Rename columns to make them easier to deal with
# And simultaneously only select columns we want to use.
# Note that all citations columns have been removed as the data validation showed this questions really confused people
# and we had wildly different answers for this across recorders.
raw_data_all <-
  rawdata %>%
  dplyr::select(paper_number = `1. Paper number`,
                doi = `2. DOI of paper (please copy paste to avoid errors)`,
                year_published = `3. Year of publication (on spreadsheet)`,
                journal = `4. Journal  (on spreadsheet)`,                                                                                                                                                                                                                                                                              
                article_type = `5. Article type  (on spreadsheet)`,                                                                                                                                                                                                                                                                         
                data_used = `7. Does the paper have data?`, 
                data_availability = `1. Are the data mentioned in the Data Availability statement?`,  
                data_availability_text = `6. Please paste the text of the Data Availability statement here`, 
                data_link = `2. Are you able to find the data using the link/instructions in the Data Availability statement?`,                                                                                                                                                                                                          
                data_archive =  `3. Where are the data archived?`,     
                data_doi = `4. Does the dataset have a DOI?`,
                data_license = `11. Does the data have a license?`,                                                                                                                                                                                                                                                                         
                data_license_type = `12. If yes, what license?`,    
                data_download = `5. Can you download the data?`,                                                                                                                                                                                                                                                                             
                data_open = `6. Can you open the data?`,                                                                                                                                                                                                                                                                                
                data_format = `7. What format are the data in?`,                                                                                                                                                                                                                                                                           
                data_README = `8. Does the data have a README/metadata?`,                                                                                                                                                                                                                                                                  
                data_README_scale = `9. How useful is the README/metadata? Read the notes in the protocol to help with decisions here. SKIP THIS Q IF NO README EXISTS.` , 
                data_completeness = `10. How complete is the archived data?`,  
                code_used = `0.1 Does the paper use code?`,
                code_alert = `0.2 If the paper uses code, and this is NOT archived (i.e. they mention using R or Python but don't provide any scripts) please copy-paste the text from the paper that alerted you to them using code...`,                                                                                                 
                code_archived = `0.3 Does the paper have archived code?`,
                code_availability = `1. Is the code archiving described in the Data Availability (or equivalent) statement?`,   
                code_link =  `2. Are you able to find the code using the link/instructions in the Data Availability (or equivalent) statement?`,                                                                                                                                                                                          
                code_archive = `3. Where are the code archived?`,
                code_doi = `4. Does the code have a DOI?`,
                code_license = `16. Does the code have a license?`,                                                                                                                                                                                                                                                                        
                code_license_type =  `17. If yes, what license?`,  
                code_CITATION = `15. Does the code have a CITATION file?`, 
                code_download = `5. Can you download the code?`,                                                                                                                                                                                                                                                                            
                code_open = `6. Can you open the code?`,                                                                                                                                                                                                                                                                              
                code_format = `8. What format is the code in?`,
                code_language = `7. What language is the code written in?`,
                code_README = `9. Does the code have a README?`, 
                code_README_scale = `10. How useful is the README? See the protocol for help with making decisions about this. SKIP THIS Q IF NO README EXISTS.`,
                code_annotation_scale = `11. How well is the code annotated? See the protocol for help with making decisions about this.`,                                                                                                                                                                                                           
                code_vignette = `12. Does the code have a separate vignette with examples of how the code should be used?`,                                                                                                                                                                                                                  
                code_Rpackage_available = `13. If the code is an R Package, and it was previously available on CRAN/Bioconductor (as stated in the Data Availability statement), is it still available? Check this by trying to install it on the most recent version of R. If you don't know how to do this/can't do this choose \"Unable to check\"`,
                code_OTHERpackage_available = `14. If the code is a package in another language (e.g. Python) published on PyPI please put the name of the package here and where it has been deposited we will see if it is still available. If you know how to look this up yourself, please do and mention whether it is still available here (Yes/No)`,
                code_application_cited = `18. APPLICATION papers only. How many times has the paper been cited? You can find this on the landing page of the paper.`,
                code_comments = `21. Do you have any other comments about the code? For example for those familiar with these processes, does the code use unit test? Doe it have continuous integration? Does it use docker/other containers?`,
                country_corresponding = `1. Country of corresponding author  (on spreadsheet)`,                                                                                                                                                                                                                                                                 
                country_first = `2. Country of first author. Use their main address on the paper. There may be more than one. We mean the address that is next to their name on the paper, NOT any “current address” that may be added for people who have recently moved institutions.`,                                                    
                georegion_data = `3. What georegion(s) were any novel data used in the paper collected from? Select all that apply. NOTE THIS MEANS DATA THAT WERE PHYSICALLY COLLECTED IN THESE COUNTRIES, DO NOT INCLUDE THINGS WHERE THE AUTHORS USED A DATASET FROM FRANCE BUT DID NOT ACTUALLY GO TO FRANCE TO COLLECT DATA :)`,         
                georegion_author_match = `4. Are any authors (use their main address on the paper) based in the georegion the data were collected from?  Also check the Acknowledgments to see if data labourers from the georegion who are not authors are mentioned there instead.`,
                georegion_data_cited = `17. For any paper(s) citing the data, what georegions are on the authors main addresses (i.e. when doing the work)? Please select all relevant options.`,                                                                                                                                                   
                equity_comments = `Any comments about data equity that these Qs don't cover?`,   
                comments = `2. Any other comments about this paper?`,                                                                                                                                                                                                                                                                   
                recorder_ID) # this column name was already updated when anonymising. 

# Look at the data pre-cleaning
glimpse(raw_data_all)

# ------------------
# CLEAN CLEAN CLEAN!
# --------------------------------------------------------------------------
# Missing details that can easily be added using either paper number or DOI
# I looked these up in the original spreadsheet of papers.
# --------------------------------------------------------------------------
# Paper numbers
raw_data_all$paper_number[178] <- 1052
raw_data_all$paper_number[1761] <- 4113
raw_data_all$paper_number[1976] <- 2272

# DOIs
raw_data_all$doi[746] <- "10.1111/1365-2664.13326"
raw_data_all$doi[1109] <- "10.1111/1365-2664.14411"
raw_data_all$doi[1611] <- "10.1111/1365-2656.13994"
raw_data_all$doi[1627] <- "10.1111/1365-2656.12727"

# Journal names
raw_data_all$journal[190] <- "Methods in Ecology and Evolution"
raw_data_all$journal[246] <- "Journal of Ecology"
raw_data_all$journal[1628] <- "Methods in Ecology and Evolution"
raw_data_all$journal[1797] <- "Journal of Ecology"

# Article types
raw_data_all$article_type[556] <- "Research Article"
raw_data_all$article_type[600] <- "Research Article"
raw_data_all$article_type[1362] <- "Research Article"
raw_data_all$article_type[1384] <- "Research Article"
raw_data_all$article_type[1610] <- "Research Article"

# Row numbers 1001, 1246 = details all missing so exclude
raw_data_all <- raw_data_all %>% slice(c(-1001, -1246))

#--------------------------------------------------------------------------
# 179 entries were flagged with issues. These were checked by Bethany A
# See fixing-papers-with-issues for details of why/how these were editted
#--------------------------------------------------------------------------
# Delete duplicated entry where second instance is correct one
# Note that there are a few more duplicates, but these will be deleted after we extract the 
# data validation paper 2272. We can't do this until we have completed the cleaning.
raw_data_all <- 
  raw_data_all %>% 
  slice(-902)

# Delete papers with issues that cannot be easily fixed
raw_data_all <- 
  raw_data_all %>% 
    filter(paper_number != 6654 & paper_number != 1343 & paper_number != 1802 &
             paper_number != 1015 & paper_number != 42 & paper_number != 6656 &
             paper_number != 1707 & paper_number != 3433 & paper_number != 3430 & 
             paper_number != 3436 & paper_number != 3440 & paper_number != 1523 & 
             paper_number != 1914 & paper_number != 3414 & paper_number != 7422 &
             paper_number != 7453 & paper_number != 3390 & paper_number != 5636 &
             paper_number != 6979 & paper_number != 6589)

# Some entire rows have been edited. Fix as follows.
# i. Read in the fixing papers with issues data
fix <- read_csv("raw-data/fixing-papers-with-issues.csv")

# ii. Subset to just the ones that need to be edited and keep only rows in the raw_data_all
fix <- 
  fix %>%
  filter(course_of_action == "Edit") %>%
  select(-c(course_of_action, justification)) %>%
  # code_application_cited is numeric here but character in raw_data_all so convert it
  mutate(code_application_cited = as.character(code_application_cited))

# iii. Loop through each paper finding the correct rows in the raw_data_all
# with these paper numbers, then replace the contents of those rows with
# the corrected data.
# I'm sure there is a better way to do this but I had limited time...
for(i in 1:length(fix$paper_number)) {
  id_row <- which(raw_data_all$paper_number == fix$paper_number[i])
  raw_data_all[id_row, ] <- fix[i, ]
  }

# --------------------------------------------------------------------------
# More complex fixes
# These proceed one variable at a time. Typos or errors are corrected
# Where "Other" was an option all options have been reviewed and corrected
# or consolidated as appropriate. Details should be clear from the code and 
# comments below, but can easily be editted if you disagree with my
# aggregating systems.
# NOTE: There are a lot of edits so this code takes a minute or so to run
# --------------------------------------------------------------------------
clean_data_all <-
  raw_data_all %>%
  #------------------------------------------------------------------------------------------------------
  # 1. Paper_number
  # Fix some typos
  mutate(paper_number = str_replace(paper_number, "32770", "3277")) %>%
  mutate(paper_number = str_replace(paper_number, "22272", "2272")) %>%
  # And return paper_number to numeric
  mutate(paper_number = as.numeric(paper_number)) %>%
  #------------------------------------------------------------------------------------------------------
  # 2. DOI
  # Some people used DOI, some used DOI link. Remove the links
  mutate(doi = str_replace_all(doi, "https://doi.org/", "")) %>%
  mutate(doi = str_replace_all(doi, "http://doi.org/", "")) %>%
  mutate(doi = str_replace_all(doi, "doi.org/", "")) %>%
  mutate(doi = str_replace_all(doi, "https://besjournals.onlinelibrary.wiley.com/doi/", "")) %>%
  # Someone pasted an ORCID, but other details match the paper number so swap for DOI
  mutate(doi = str_replace(doi, "https://orcid.org/0009-0008-2457-8954", "10.1111/1365-2656.13383")) %>%
  #------------------------------------------------------------------------------------------------------
  # 3. Journal
  # Fix one paper with incorrect journal name
  mutate(doi = str_replace(doi, "Ecology and Evolution", "Methods in Ecology and Evolution")) %>%
  #------------------------------------------------------------------------------------------------------
  # DATA!!!                                                                                                                                                                                       
  #------------------------------------------------------------------------------------------------------
  # 4. Data used
  # Two papers have NA for data_used, but then go onto answer data questions so should be Yes
  mutate(data_used = replace_na(data_used, "Yes")) %>%
  # One paper incorrectly states that data was used when it wasn't, fix.
  mutate(data_used = case_when(paper_number == 1603 ~ "No",
                                       TRUE ~ as.character(data_used))) %>%
  #------------------------------------------------------------------------------------------------------
  # IF NO DATA ARE USED, ANSWERS FOR ALL OTHER DATA QUESTIONS SHOULD BE NA (EXCEPT DATA AVAIL TEXT)
  mutate(data_availability = case_when(data_used == "No" ~ NA_character_, TRUE ~ as.character(data_availability))) %>%
  mutate(data_link = case_when(data_used == "No" ~ NA_character_, TRUE ~ as.character(data_link))) %>%
  mutate(data_archive = case_when(data_used == "No" ~ NA_character_, TRUE ~ as.character(data_archive))) %>%
  mutate(data_doi = case_when(data_used == "No" ~ NA_character_, TRUE ~ as.character(data_doi))) %>%
  mutate(data_license = case_when(data_used == "No" ~ NA_character_, TRUE ~ as.character(data_license))) %>%
  mutate(data_license_type = case_when(data_used == "No" ~ NA_character_, TRUE ~ as.character(data_license_type))) %>%
  mutate(data_download = case_when(data_used == "No" ~ NA_character_, TRUE ~ as.character(data_download))) %>%
  mutate(data_open = case_when(data_used == "No" ~ NA_character_, TRUE ~ as.character(data_open))) %>%
  mutate(data_format = case_when(data_used == "No" ~ NA_character_, TRUE ~ as.character(data_format))) %>%
  mutate(data_README = case_when(data_used == "No" ~ NA_character_, TRUE ~ as.character(data_README))) %>%
  mutate(data_README_scale = case_when(data_used == "No" ~ NA_character_, TRUE ~ as.character(data_README_scale))) %>%
  mutate(data_completeness = case_when(data_used == "No" ~ NA_character_, TRUE ~ as.character(data_completeness))) %>%
  
  #------------------------------------------------------------------------------------------------------
  # 5. Data mentioned in data availability statement
  # Several people forgot to answer this question. 
  # Checked and answered appropriately.
  mutate(data_availability = case_when(paper_number == 1897 ~ "Yes",
                                       paper_number == 245 ~ "Yes",
                                       paper_number == 346 ~ "Yes",
                                       paper_number == 1132 ~ "Yes",
                                       paper_number == 1595 ~ "Yes",
                                       TRUE ~ as.character(data_availability))) %>%
  #------------------------------------------------------------------------------------------------------
  # IF DATA ARE ONLY AVAILABLE ON REQUEST, OR NOT IN THE DATA AVAILABILITY STATEMENT AT ALL,
  # ANSWERS FOR ALL OTHER DATA QUESTIONS SHOULD BE NA (EXCEPT DATA AVAIL TEXT)
  mutate(data_link = case_when(data_availability == "No, but they are available on request" | data_availability == "No" ~ NA_character_, TRUE ~ as.character(data_link))) %>%
  mutate(data_archive = case_when(data_availability == "No, but they are available on request" | data_availability == "No" ~ NA_character_, TRUE ~ as.character(data_archive))) %>%
  mutate(data_doi = case_when(data_availability == "No, but they are available on request" | data_availability == "No" ~ NA_character_, TRUE ~ as.character(data_doi))) %>%
  mutate(data_license = case_when(data_availability == "No, but they are available on request" | data_availability == "No" ~ NA_character_, TRUE ~ as.character(data_license))) %>%
  mutate(data_license_type = case_when(data_availability == "No, but they are available on request" | data_availability == "No" ~ NA_character_, TRUE ~ as.character(data_license_type))) %>%
  mutate(data_download = case_when(data_availability == "No, but they are available on request" | data_availability == "No" ~ NA_character_, TRUE ~ as.character(data_download))) %>%
  mutate(data_open = case_when(data_availability == "No, but they are available on request" | data_availability == "No" ~ NA_character_, TRUE ~ as.character(data_open))) %>%
  mutate(data_format = case_when(data_availability == "No, but they are available on request" | data_availability == "No" ~ NA_character_, TRUE ~ as.character(data_format))) %>%
  mutate(data_README = case_when(data_availability == "No, but they are available on request" | data_availability == "No" ~ NA_character_, TRUE ~ as.character(data_README))) %>%
  mutate(data_README_scale = case_when(data_availability == "No, but they are available on request" | data_availability == "No" ~ NA_character_, TRUE ~ as.character(data_README_scale))) %>%
  mutate(data_completeness = case_when(data_availability == "No, but they are available on request" | data_availability == "No" ~ NA_character_, TRUE ~ as.character(data_completeness))) %>%
  #------------------------------------------------------------------------------------------------------
  # 6. Can you open the link? 
  # Some people have not answered this although data are mentioned in the data availability statement
  # Checked and answered appropriately.
  mutate(data_link = case_when(paper_number == 1003 ~ "Yes",
                                       paper_number == 1045 ~ "Yes",
                                       paper_number == 2697 ~ "Yes",
                                       paper_number == 1527 ~ "Yes",
                                       paper_number == 5561 ~ "Yes",
                                       paper_number == 2288 ~ "Yes",
                                       TRUE ~ as.character(data_link)))     %>% 
  #------------------------------------------------------------------------------------------------------       
  # 7. Data archive 
  # Correcting errors in data archive. Some should have NA here as no data are available. 
  # Lots are institutional repos
  # ### CHECK THESE NA ONES AS THEY SHOULD NOT SAY DATA IS ARCHIVED
  mutate(data_archive = case_when(data_archive == "According to ethical requirements data is available only upon request to the authors." |
                                      data_archive == "Data held by one author and the Missouri Department of Conservation" |                                                                                                                                                                                                                                                                                                                                                    
                                      data_archive == "Data is only available on request." |                                                                                                                                                                                                                                                                                                                                                                                      
                                      data_archive == "Data NOT archived because of twitter privacy terms." |
                                      data_archive == "As a list of citations to third-party data sources" |
                                      data_archive == "Figure 3 in the methods section, and the immediaately proceeding paragraph." |                                                                                                                                                                                                                                                                                                                                            
                                      data_archive == "From other cited documents, but not findable in Google Scholar. So no access to data." |
                                      data_archive == "In the manuscript" |                                                                                                                                                                                                                                                                                                                                                                                                      
                                      data_archive == "In the paper itself" |
                                      data_archive == "It is a metaanalysis, point interested readers to the list of revised papers" |                                                                                                                                                                                                                                                                                                                                           
                                      data_archive == "Kenyan STR profiles are unshareable." |  
                                      data_archive == "nowhere" |
                                      data_archive == "On request" |
                                      data_archive == "The aphid and plankton data used for this study can be obtained after getting permission from the data owners, the Rothamsted Insect Survey and the Sir Alister Hardy Foundation for Ocean Science, which is part of the Marine Biological Association of the UK. Chlorophyll data from the California current were processed from https://coastwatch.pfeg.noaa.gov/erddap/tabledap/index.html?page=1&itemsPerPage=1000."
                                      ~ NA_character_,
                                      
                                      data_archive == "Dryad;website on publication" |
                                      data_archive == "The data is archived here but I can't open the link: https://doi:10.5061/dryad.vk002fn"   
                                      ~ "Dryad",
                                      
                                      # Most options have very low numbers so simplify to "Other repo/database"
                                      # This includes institutional repositories, national data centres like CEFAS/USGS, databases for specific
                                      # projects like MOVEBANK, NCBI GenBank, OSF and DataVerse.
                                      data_archive == "DataVerse" |
                                      data_archive == "DataVerse;EDI Data Portal" |
                                      data_archive == "Institutional repository" |
                                      data_archive == "OSF (https://osf.io/)" |
                                      data_archive == "Apollo - University of Cambridge Repository" |
                                      data_archive == "Arctic Data Center" | data_archive == "Arctic Data Centre"|
                                      data_archive == "Australian Antarctic Data Centre"  | 
                                      data_archive == "Australian National University Data Commons" | 
                                      data_archive == "CEFAS"  |                                                                                                                                                                                                                                                                                                                                                                                                                 
                                      data_archive == "DANS" |                                                                                                                                                                                                                                                                                                                                                                                                                   
                                      data_archive == "DANS Data Station Life Sciences"   |                                                                                                                                                                                                                                                                                                                                                                                      
                                      data_archive == "data.4tu.nl"  |                                                                                                                                                                                                                                                                                                                                                                                                           
                                      data_archive == "data.gov.uk"  |
                                      data_archive == "Data Repository of the University of Minnesota" |
                                      data_archive == "Digital.CSIC"  |
                                      data_archive == "EDI Data Portal"  |                                                                                                                                                                                                                                                                                                                                                                                                       
                                      data_archive == "EDI Repository" |
                                      data_archive == "Edinburgh DataShare" |                                                                                                                                                                                                                                                                                                                                                                                                    
                                      data_archive == "EDMOND Digital Repository" |                                                                                                                                                                                                                                                                                                                                                                                              
                                      data_archive == "envidat.ch data portal of the Swiss Federal Institute for Forest, Snow and Landscape Research WSL" |                                                                                                                                                                                                                                                                                                                      
                                      data_archive == "Environmental Data Initiative" |                                                                                                                                                                                                                                                                                                                                                                                           
                                      data_archive == "Environmental Data Initiative (EDI Data Portal)" |                                                                                                                                                                                                                                                                                                                                                                        
                                      data_archive == "Environmental Data Initiative (EDI) Data Portal" |                                                                                                                                                                                                                                                                                                                                                                        
                                      data_archive == "Environmental Data Initiative (https://portal.edirepository.org/nis/home.jsp)" |                                                                                                                                                                                                                                                                                                                                          
                                      data_archive == "Environmental Data Initiative and Kellogg Biological Station LTER website (deposited here as required by the Funding)" |                                                                                                                                                                                                                                                                                                   
                                      data_archive == "erda.dk" |
                                      data_archive == "Etsin" |
                                      data_archive == "Government repository (National Science Foundation Arctic Data Center)" |                                                                                                                                                                                                                                                                                                                                                 
                                      data_archive == "Government repository (USGS)"  |                                                                                                                                                                                                                                                                                                                                                                                          
                                      data_archive == "Griffith University and Walalakoo Aboriginal Corporation" |                                                                                                                                                                                                                                                                                                                                                                
                                      data_archive == "Harvard Dataverse" |                                                                                                                                                                                                                                                                                                                                                                                                       
                                      data_archive == "https://data.botanik.uni-halle.de/bef-china/datasets/655" |                                                                                                                                                                                                                                                                                                                                                               
                                      data_archive == "https://data.neotomadb.or" |                                                                                                                                                                                                                                                                                                                                                                                              
                                      data_archive == "https://ged.ofb.fr"  |                                                                                                                                                                                                                                                                                                                                                                                                    
                                      data_archive == "https://radar.brookes.ac.uk/"|                                                                                                                                                                                                                                                                                                                                                                                            
                                      data_archive == "https://researchdata.se/"   |                                                                                                                                                                                                                                                                                                                                                                                             
                                      data_archive == "https://www.bco-dmo.org/dataset/639335"  |                                                                                                                                                                                                                                                                                                                                                                                
                                      data_archive == "Illinois Data Bank (https://databank.illinois.edu/)" |                                                                                                                                                                                                                                                                                                                                                                    
                                      data_archive == "IMIS - the Integrated Marine Information System https://www.vliz.be/en/imis" |
                                      data_archive == "INRAE - French government" |
                                      data_archive == "Institutional repository;4TU.ResearchData" |                                                                                                                                                                                                                                                                                                                                                                              
                                      data_archive == "Institutional repository;Environmental Data Initiative"  |                                                                                                                                                                                                                                                                                                                                                                
                                      data_archive == "Institutional repository;European Tracking Network (ETN) database (https://lifewatch.be/etn)" |                                                                                                                                                                                                                                                                                                                           
                                      data_archive == "Institutional repository;Government databases."  |                                                                                                                                                                                                                                                                                                                                                                        
                                      data_archive == "Institutional repository;https://datastore.landcareresearch.co.nz"   |                                                                                                                                                                                                                                                                                                                                                    
                                      data_archive == "Institutional repository;https://dataverse.nl" |
                                      data_archive == "Institutional repository;Linked to another journal"  |                                                                                                                                                                                                                                                                                                                                                                    
                                      data_archive == "Institutional repository;MassIVE, ProteomeXchange" |
                                      data_archive == "Institutional repository;Official archive of publicly accessible USGS source code (https://code.usgs.gov/usgs)"  |                                                                                                                                                                                                                                                                                                        
                                      data_archive == "Institutional repository;Research Data Australia (RDA) online portal"     |                                                                                                                                                                                                                                                                                                                                               
                                      data_archive == "KNB (The Knowledge Network for Biocomplexity, https://knb.ecoinformatics.org/)"  |                                                                                                                                                                                                                                                                                                                                        
                                      data_archive == "Knowledge Network for Biocomplexity"     |                                                                                                                                                                                                                                                                                                                                                                                
                                      data_archive == "Knowledge Network for Biocomplexity (KNB)"  |                                                                                                                                                                                                                                                                                                                                                                             
                                      data_archive == "Knowledge Network for Biocomplexity (KNB) repository" |                                                                                                                                                                                                                                                                                                                                                                   
                                      data_archive == "Labeled Information Library of Alexandria: Biology and Conservation" |                                                                                                                                                                                                                                                                                                                                                    
                                      data_archive == "Lancaster University"  |
                                      data_archive == "mandeley"   |                                                                                                                                                                                                                                                                                                                                                                                                             
                                      data_archive == "Mendeley"|                                                                                                                                                                                                                                                                                                                                                                                                                
                                      data_archive == "Mendeley Data"|                                                                                                                                                                                                                                                                                                                                                                                                           
                                      data_archive == "MendeleyData" |                                                                                                                                                                                                                                                                                                                                                                                                           
                                      data_archive == "Mendely Data"  |                                                                                                                                                                                                                                                                                                                                                                                                          
                                      data_archive == "Metabolights"   |                                                                                                                                                                                                                                                                                                                                                                                                         
                                      data_archive == "Metacat Data Catalog" |                                                                                                                                                                                                                                                                                                                                                                                                   
                                      data_archive == "metagenomics RAST server" |
                                      data_archive == "MyDiv" |                                                                                                                                                                                                                                                                                                                                                                                                                   
                                      data_archive == "National Tibetan Plateau Data Center" |
                                      data_archive == "NERC EIDC" |                                                                                                                                                                                                                                                                                                                                                                                                              
                                      data_archive == "NERC Environmental Information Data Centre" |                                                                                                                                                                                                                                                                                                                                                                             
                                      data_archive == "NSF Arctic Data Center"     |                                                                                                                                                                                                                                                                                                                                                                                             
                                      data_archive == "OFD (Office Français de la Biodiversité"    |                                                                                                                                                                                                                                                                                                                                                                             
                                      data_archive == "Oxford Research Archive" |                                                                                                                                                                                                                                                                                                                                                                                                
                                      data_archive == "pangaea"     |                                                                                                                                                                                                                                                                                                                                                                                                            
                                      data_archive == "PANGAEA" |                                                                                                                                                                                                                                                                                                                                                                                                                
                                      data_archive == "Pangaea repository" |                                                                                                                                                                                                                                                                                                                                                                                                     
                                      data_archive == "PANGAEA."     |                                                                                                                                                                                                                                                                                                                                                                                                           
                                      data_archive == "Purdue University Research Repository"    |                                                                                                                                                                                                                                                                                                                                                                               
                                      data_archive == "R script on ARP Adatrepozitorium"  |                                                                                                                                                                                                                                                                                                                                                                                      
                                      data_archive == "researchdata.gla.ac.uk" |                                                                                                                                                                                                                                                                                                                                                                                                 
                                      data_archive == "researchdata.se"    |                                                                                                                                                                                                                                                                                                                                                                                                     
                                      data_archive == "Researchdata.se"  |                                                                                                                                                                                                                                                                                                                                                                                                       
                                      data_archive == "ScienceBase"   |                                                                                                                                                                                                                                                                                                                                                                                                          
                                      data_archive == "sciencebase.gov"|                                                                                                                                                                                                                                                                                                                                                                                                         
                                      data_archive == "Senckenberg (meta)data portal"   |                                                                                                                                                                                                                                                                                                                                                                                        
                                      data_archive == "Sequence Read Archive (SRA)"   |                                                                                                                                                                                                                                                                                                                                                                                          
                                      data_archive == "Smithsonian"       |                                                                                                                                                                                                                                                                                                                                                                                                      
                                      data_archive == "Some are available on Research Data Repository of the Research Collection of ETH Zürich, others are available on request"  |
                                      data_archive == "the Harvard Dataverse repository"  |                                                                                                                                                                                                                                                                                                                                                                                      
                                      data_archive == "U.S. Geological Survey Data Release."  |                                                                                                                                                                                                                                                                                                                                                                                  
                                      data_archive == "United States Geological Survey (USGS)"   |                                                                                                                                                                                                                                                                                                                                                                               
                                      data_archive == "University (but not available)"      |                                                                                                                                                                                                                                                                                                                                                                                    
                                      data_archive == "University of Illinois databank"  |                                                                                                                                                                                                                                                                                                                                                                                       
                                      data_archive == "University of Vienna" |                                                                                                                                                                                                                                                                                                                                                                                                   
                                      data_archive == "USGS"       |                                                                                                                                                                                                                                                                                                                                                                                                             
                                      data_archive == "USGS Science Base"   |                                                                                                                                                                                                                                                                                                                                                                                                    
                                      data_archive == "USGS ScienceBase"  |                                                                                                                                                                                                                                                                                                                                                                                                      
                                      data_archive == "USGS ScienceBase online data repository platform" |                                                                                                                                                                                                                                                                                                                                                                       
                                      data_archive == "USGS ScienceBase website and digital repository"  | 
                                      data_archive == "ziva hub" |                                                                                                                                                                                                                                                                                                                                                                                                               
                                      data_archive == "ZivaHub" |
                                      data_archive == "edi repository and Bonanza Creek LTER web page" |
                                      data_archive == "Ecological Archives" |
                                      data_archive == "Forest Plots" |
                                      data_archive == "International Tree-Ring Data Bank" |
                                      data_archive == "MoveBank"  |                                                                                                                                                                                                                                                                                                                                                                                                              
                                      data_archive == "Movebank and the r package ‘moveVis’" |
                                      data_archive == "Neotoma Paleoecology Database" |
                                      data_archive == "NCBI" |
                                      data_archive == "NCBI SRA"   |                                                                                                                                                                                                                                                                                                                                                                                                             
                                      data_archive == "NCBI SRA database"  |
                                      data_archive == "NCBI GenBank;Environmental Information Data Centre"  |                                                                                                                                                                                                                                                                                                                                                                  
                                      data_archive == "NCBI GenBank;PlutoF" |
                                      data_archive == "GBIF"     |                                                                    
                                      data_archive == "Institutional repository;NCBI GenBank" |
                                      data_archive == "NCBI GenBank" 
                                      ~ "Other repo/database",
                                      
                                      data_archive == "Dryad;Institutional repository" |
                                      data_archive == "Dryad;and USGS"  |                                                                                                                                                                                                                                                                                                                                                                                                       
                                      data_archive == "Dryad;CEFAS"   |                                                                                                                                                                                                                                                                                                                                                                                                          
                                      data_archive == "Dryad;ENA" |
                                      data_archive == "Dryad;NCBI GenBank;Arctos" |
                                      data_archive == "Dryad;Czech Quaternary Palynological Database" |
                                      data_archive == "Dryad;\"Trait data can be accessed through the TRY database: https://www.try-db.org (Kattge et al., 2020) and BIEN database: https://bien.nceas.ucsb.edu/bien/ (Enquist et al., 2016).\""  |
                                      data_archive == "Dryad;https://compadre-db.org/" |                                                                                                                                                                                                                                                                                                                                                                                         
                                      data_archive == "Dryad;https://datarepository.movebank.org/ and https://vigiechiro.herokuapp.com/"  |                                                                                                                                                                                                                                                                                                                                      
                                      data_archive == "Dryad;MoveBank" |                                                                                                                                                                                                                                                                                                                                                                                                          
                                      data_archive == "Dryad;MOVEBANK" |
                                      data_archive == "Dryad;TRY Database" |   
                                      data_archive ==  "Dryad;NCBI GenBank" |
                                      data_archive == "Dryad;TRY database, Dataset 416" |  
                                      data_archive == "Dryad;World Spider Trait Databasde" |
                                      data_archive == "Dryad;Only part of the data (that were uploaded on DRYAD) can be accessed. The data availability statement points to another source: LOng-Term Vegetation Sampling database https://lotvs.csic.es/ and is partially restricted." |                                                                                                                                                                                        
                                      data_archive == "Dryad;sequence data are archived in the MG-RAST public database (Project ID: 4745987.3)"
                                      ~ "Dryad;Other repo/database",  
                                    
                                      data_archive == "Dryad;NCBI GenBank;Supplementary materials"  
                                      ~ "Dryad;Supplementary materials;Other repo/database",
                                      
                                      data_archive == "Dryad;GitHub, GitLab, Codeberg or similar platform;FlickR"  
                                      ~ "Dryad;GitHub, GitLab, Codeberg or similar platform;Other repo/database",
                                      
                                      data_archive == "Dryad;GitHub, GitLab, Codeberg or similar platform;NCBI GenBank;Zenodo"  
                                      ~ "Dryad;GitHub, GitLab, Codeberg or similar platform;Zenodo;Other repo/database",
                                      
                                      data_archive == "Dryad;Personal website;forestplots.net" 
                                      ~ "Dryad;Personal website;Other repo/database",
        
                                      data_archive == "Figshare;FUNdiv" |
                                      data_archive == "Figshare;Movebank" |
                                      data_archive == "Figshare;https://archive.org/" |
                                      data_archive ==   "Figshare;Institutional repository" |
                                      data_archive == "Figshare;NCBI GenBank"
                                        ~ "Figshare;Other repo/database",
                                      
                                      data_archive == "Figshare;GitHub, GitLab, Codeberg or similar platform;Authors used data form a published study archived on Figshare. They also simulated some data for one of the result figures and archived it on Github"  
                                      ~ "Figshare;GitHub, GitLab, Codeberg or similar platform",

                                      data_archive == "Figshare;Institutional repository;They refer to it as the institutional repository but it is a Figshare wrapper."
                                      ~ "Figshare",
                                      
                                      data_archive == "GitHub, GitLab, Codeberg or similar platform;CRAN" |
                                      data_archive == "GitHub, GitLab, Codeberg or similar platform;Cran; data is part of an r-packge."
                                      ~ "GitHub, GitLab, Codeberg or similar platform",
                                      
                                      data_archive == "GitHub, GitLab, Codeberg or similar platform;Knowledge Network for Biocomplexity" |
                                      data_archive ==   "GitHub, GitLab, Codeberg or similar platform;Institutional repository" 
                                      ~ "GitHub, GitLab, Codeberg or similar platform;Other repo/database", 
                                      
                                      data_archive == "GitHub, GitLab, Codeberg or similar platform;Supplementary materials;Zenodo;The authors have the data saved in the supplementary material. This is archived in GitHub and one of the versions is archived in Zenodo." 
                                      ~ "Zenodo",
                                      
                                      data_archive == "GitHub, GitLab, Codeberg or similar platform;Zenodo;R CRAN"  |                                                                                                                                                                                                                                                                                                                                                            
                                      data_archive == "GitHub, GitLab, Codeberg or similar platform;Zenodo;R package on CRAN" 
                                      ~ "GitHub, GitLab, Codeberg or similar platform;Zenodo",
                                      
                                      data_archive == "Supplementary materials;ESS-DIVE, Google Earth Engine. Links are included in Supplementary Material 4" |
                                      data_archive == "Supplementary materials;Mendeley Data Repository" |  
                                      data_archive == "Institutional repository;Supplementary materials" 
                                      ~ "Supplementary materials;Other repo/database",
                                      
                                      data_archive == "Zenodo;DOI not found" |
                                      data_archive == "Zenodo;R Cran"  
                                      ~ "Zenodo",
                                      
                                      data_archive == "Zenodo;EMBL-EBI" |
                                      data_archive == "Zenodo;Google Earth Engine" |
                                      data_archive == "Zenodo;https://www.fs.usda.gov/rds/archive/Catalog/RDS-2015-0010"  |                                                                                                                                                                                                                                                                                                                                                      
                                      data_archive == "Zenodo;Pangea"    |                                                                                                                                                                                                                                                                                                                                                                                                       
                                      data_archive == "Zenodo;Phenology Observation Portal" |
                                      data_archive == "GBIF;Zenodo"
                                      ~ "Zenodo;Other repo/database",
                                      
                                      TRUE ~ as.character(data_archive))) %>%
  #------------------------------------------------------------------------------------------------------
  # 8. Dataset DOI
  # All other options can be simplified to No/Yes/Yes but not for all data archived/Yes but DOI not found/incorrect                                                                                                                                                                                                                                                                                                                                                                                             
  mutate(data_doi = case_when(data_doi == "Accession number: SRP151262" |
                            data_doi == "Accession numbers"  |
                            data_doi == "As it is supplementary materials it does not have an individual doi, but is of course associated with the paper's doi." |
                            data_doi == "Has Accession Number"  |                                                                                                                                                                                                                                
                            data_doi == "I think no, but it has an accession ID" |
                            data_doi == "Yes, assuming the data is = the r-package" |
                            data_doi == "The data is stored in the CRAN and Github repositories (it is an R package). These do not have a DOI per se. The Open Research Statement does not explicitly refer to the data either, but you can find it in the repositories to which you are linked." |
                            data_doi == "There is a doi for instructions/code but no dataset present" |
                            data_doi == "No link to data in Data Availability Statement"  |                                                                                                                                                                                                       
                            data_doi == "No, data is not publicly available for confidentiality reasons" 
                            ~ "No",
                                      
                            data_doi == "Data deposited in Dryad has a DOI, data deposited in NCBI does not" |
                            data_doi ==  "Dryad dataset = yes, NCBI dataset = no" |
                            data_doi == "first dataset has a doi, second does not" |                                                                                                                                                                                                               
                            data_doi == "First dataset yes, second no" |
                            data_doi ==  "Pre-existing data has DOI, simulated data does not have DOI" |
                            data_doi ==  "Yes for the data on DRYAD" |
                            data_doi ==  "Yes for the dryad data but not for the MG-RAST sequence data" |                                                                                                                                                                                           
                            data_doi ==  "yes for the dryad data, unsure about the genetic data"  
                            ~ "Yes, but not for all data archived",
                            
                            data_doi == "DOI not found" |
                            data_doi == "repo has a DOI, but repo does not contain the data" |
                            data_doi == "not available \"The application or website you were looking for is known on this server, but it is currently not available\""  |                                                                                                                         
                            data_doi == "The link to the data does not open." |
                            data_doi == "Yes but not detailed in the original publication [redirected through handle.net]" |
                            data_doi == "they have a DOI link but it is from another paper (check - https://doi.org/10.3389/fcimb.2025.1538459.s001)" 
                            ~ "Yes, but DOI not found/incorrect",
                              
                            data_doi == "There are two data available in one DOE, and the other one is a link to ENA" |
                            data_doi == "Yes, but it's archived with the code so the DOI is for both"   
                              ~ "Yes",
                                    
                            TRUE ~ as.character(data_doi))) %>%
  #------------------------------------------------------------------------------------------------------
  # 9. Data license
  # All other options can be simplified to No/Yes/Yes but not for all data archived                                                                                                                                                                                                                                                                                                                                                                                             
  mutate(data_license = case_when(data_license == "Data not available" |                                                
                                  data_license == "Data not available (Kenyan STR profiles are unshareable.)"|    
                                  data_license == "no License could be found on the OSF repository."|
                                  data_license == "No link to data in Data Availability Statement" |
                                  data_license == "The data is included in the R package"|                              
                                  data_license == "The data is only available on request."|                             
                                  data_license == "The link to the data does not open."    |                            
                                  data_license == "The link was unavailable." 
                                  ~ "No",
  
                                  data_license == "First dataset yes, second no"  |
                                  data_license == "Pre-existing data has license, simulated data does not have license" |
                                  data_license == "Yes for the data on DRYAD"
                                  ~ "Yes, but not for all data archived",
  
                                  data_license == "Just says \"Other (Open)\"" |                                        
                                  data_license == "License: Other (Attribution)" |
                                  data_license == "Yes, 2 licences. One for DRYAD and one for Open Access BES Journal."
                                  ~ "Yes",
  
                                  TRUE ~ as.character(data_license))) %>%
  #------------------------------------------------------------------------------------------------------
  # 10. Data license type
  # If data_license = No then data_license_type should be NA
  mutate(data_license_type = case_when(data_license == "No" ~ NA_character_, 
                                       TRUE ~ as.character(data_license_type))) %>%    
  
  # My choices here might be more controversial, sorry! 
  # I've combined all CC BY derivatives, e.g. CC BY-ND into one option: 'CC BY derivatives', as there are not many for each type.
  # Most specific licenses (e.g. GPL, MIT) have been changed to "Other". 
  # I've added OGL as an option as this came up a lot.
  # Many Zenodo based projects have license Other (open), but no other details of the license, so I classified this as "Other".
  # CC 4.0 == CC BY, this has been corrected.
  # Dryad uses CC0 (since 2009), so anyone using Dryad should have CC0 license selected.
  # Where multiple licenses are listed (rare) I have chosen the most restrictive.
  # Note for interpretation, I think some people confused code and data licenses here.
  mutate(data_license_type = case_when(data_license_type == "CC 4.0" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                       data_license_type == "CC Attribution 4.0 International; Other (Open)" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                                       data_license_type == "CC BY 4.0" |
                                       data_license_type == "CC BY;\"Other (Open)\"" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                       data_license_type == "CC BY;CC BY 4.0" |
                                       data_license_type == "CC BY;CC-BY-3.0" |
                                       data_license_type == "CC BY;CC0" |
                                       data_license_type == "CC0;CC BY 4.0" |
                                       data_license_type == "etalab open licence 2.0, compatible CC BY 2.0" |
                                       data_license_type == "Atribución" 
                                       ~ "CC BY",
                                       
                                       data_license_type == "CC BY-NC" |
                                       data_license_type == "CC BY;CC BY-NC-ND" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
                                       data_license_type == "CC BY-NC-ND" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                                       data_license_type == "CC BY-NC-SA" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                                       data_license_type == "CC BY-ND"  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                                       data_license_type == "CC BY-SA" 
                                       ~ "CC BY derivatives",
                      
                                       data_license_type == "\"Public domain\"" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
                                       data_license_type == "CC0 1.0 Universal" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                       data_license_type == "CC0; CC0 1.0"  |
                                       data_license_type == "CC0;CC0 1.0" |
                                       data_license_type == "CC0;ODbL" |
                                       data_license_type == "Common Creative Attribution 4.0 International" |
                                       data_license_type == "Craetive Common Attributions License 4.0"   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
                                       data_license_type == "Creative Commons Attribution 4.0 International"  |
                                       data_license_type == "Public" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                       data_license_type == "Public domain" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                                       data_license_type == "Public Domain" |
                                       data_license_type == "US Public Domain" |
                                       data_license_type == "CC0;\"Contact corresponding author\" statement to use all or part of data." 
                                       ~ "CC0",
                                       
                                       # OGL
                                       data_license_type == "Open Database License (ODbL)" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                                       data_license_type == "Open Government Licence" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                                       data_license_type == "Open Government Licence - Canada" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                       data_license_type == "Open Government Licence (OGL)" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                                       data_license_type == "Open Government Licence (OGL), for public data."|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                                       data_license_type == "Open Government Licence v3"    |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                                       data_license_type == "Open Government Licence v3 (OGL)" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
                                       data_license_type == "OGL (Open Government Licence)" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                                       data_license_type == "OGL (Open Government Licence) by the UK government" 
                                       ~ "OGL",
                                       
                                       # Dryad is CC0, so any paper using Dryad is CC0
                                       data_archive == "Dryad" ~ "CC0",
                                       
                                       # other
                                       data_license_type == "Community Data License Agreement - Permissive" |
                                       data_license_type == "Custom: Permitted reuse with acknowledgement I AGREE TO ACKNOWLEDGE any re-use of this dataset in any research outputs where reliance is made upon it, including conference papers and published research papers.   The agreed form of acknowledgement is as a full citation as presented on the UQ eSpace record for this dataset"|                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                       data_license_type == "Data within R package (License: GPL)"  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                       data_license_type == "EMBL-EBI" |  
                                       data_license_type == "Free use databases" |
                                       data_license_type == "GNU AFFERO GENERAL PUBLIC LICENSE" |
                                       data_license_type == "GNU General Public License"  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                                       data_license_type == "GPL 3.0"  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
                                       data_license_type == "GPL-3.0" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                                       data_license_type == "GPL2"  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                       data_license_type == "GPL3.0" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
                                       data_license_type == "Intellectual Rights statement: \"This dataset is released to the public and may be freely downloaded. Please keep the designated Contact person informed of any plans to use the dataset. Consultation or collaboration with the original investigators is strongly encouraged. Publications and data products that make use of the dataset must include proper acknowledgement. For more information on the Bromeliad Working Group data access, and for other data about this fauna, please see: www.zoology.ubc.ca/~srivast/bwg\"" |                                                                                                                                                                                                                                                                 
                                       data_license_type ==  "MIT" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                       data_license_type == "MIT license"   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                                       data_license_type == "MIT License" |
                                       data_license_type == "Please cite original publication, online resource, dataset and publication DOIs (where available), and date accessed when using downloaded data. If there is no publication information, please cite investigator, title, online resource, and date accessed. The appearance of external links associated with a dataset does not constitute endorsement by the Department of Commerce/National Oceanic and Atmospheric Administration of external Web sites or the information, products or services contained therein. For other than authorized activities, the Department of Commerce/NOAA does not exercise any editorial control over the information you may find at these locations. These links are provided consistent with the stated purpose of this Department of Commerce/NOAA Web site." |
                                       data_license_type ==  "License: Other (Attribution)" |
                                       data_license_type == "It says the licence is \"Open\"" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                                       data_license_type == "Licence listed on Zenodo as \"Other (Open)\""|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
                                       data_license_type == "License: Open (Other)"  |
                                       data_license_type == "Open" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                       data_license_type == "open (other)"   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
                                       data_license_type == "Other (open)"  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                                       data_license_type == "Other (Open)" |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
                                       data_license_type == "Other (Open) / MIT License (GitHub repo)"  |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                       data_license_type == "Other (Open) on zenodo, GPL-3.0 on github (not specific to the data)"  |
                                       data_license_type == "Stated as \"Other (Open)\"" |
                                       data_license_type == "'other (open)'" |  
                                       data_license_type == "\"Open\" is stated on the Zenodo landing page." | 
                                       data_license_type == "\"Other (Open)\"" | 
                                       data_license_type == "\"Other (Open)\" as mentioned"  | 
                                       data_license_type == "\"Other (Open)\" but doesn't specify terms of the licence."  | 
                                       data_license_type == "(open)"| 
                                       data_license_type == "(Open)" | 
                                       data_license_type == "Twitter’s own licensing" |
                                       data_license_type == "The author" |
                                       data_license_type == "\"YEAR: 2017 COPYRIGHT HOLDER: Ian Vaughan\" in the LICENCE file of the package" |  
                                       data_license_type == "GPL"
                                       ~ "Other",
                                       
                                       # These should be NA
                                       data_license_type == "The link to the data does not open." |
                                       data_license_type == "The link was unavailable." 
                                       ~ NA_character_,
                                       
                                       TRUE ~ as.character(data_license_type))) %>%

  #------------------------------------------------------------------------------------------------------
  # 11. Can you download the data?
  # Data that do not have a link cannot be downloaded so make this NA
  mutate(data_download = case_when(data_link == "No"  | is.na(data_link) ~ NA_character_,                                                                                               
                             TRUE ~ as.character(data_download))) %>%
  # Mostly these can be classed as Yes/No/No - because the data are embargoed
  # But for some papers with multiple datasets I've added a 'Yes, but not all data' option
  # A bit of debate here about what should be No versus NA...
  mutate(data_download = case_when(data_download == "Details of the LANDSAT images are listed - so maybe if I knew more about it" |
                                   data_download == "DOI not found" |
                                   data_download == "Hard to tell if the data this links to is reference genome data that was created prior to this project, I cannot see where to download the project-specific data."|
                                   data_download == "I can only access, download and open 1 out of 3 datasets that the Data Availability Statement linked to" |
                                   data_download == "I could not find the option to download the data." |
                                   data_download == "I cannot currently access the institutional repository page as I am getting a website certificate error (Safari will not let me load the page)" |                                                                               
                                   data_download == "NCBI cloud data delivery requires login" |
                                   data_download == "No - \"Full transcripts of the interviews cannot be made available to avoid compromising respondents' anonymity\""  |                                                                                                           
                                   data_download == "no - due to confidentiality - unsure if that classifies as emnargoed" |
                                   data_download == "No - ERROR: Malformed PASS accession number 'SRP218212'. It should be PASSnnnnn, where nnnnn is a 5-digit number. Please enter the correct accession number. - number provided was incorrect" |                                 
                                   data_download == "no link provided, no clear dataset to download when I search for BioProject accession number on SRA" |                                                                                                                          
                                   data_download == "No, data is not publicly available for confidentiality reasons" |                                                                                                                                                               
                                   data_download == "No, folder empty" |                                                                                                                                                                                                             
                                   data_download == "No, security issue ‘Your connection is not private Attackers might be trying to steal your information from au-east.erc.monash.edu.au (for example, passwords, messages, or credit cards).’ when attempting to download data\"" |
                                   data_download == "No. because \"The requested service is temporarily unavailable. Please try later.\"" |                                                                                                                                          
                                   data_download == "No. I need to send request to authors from OSF account for data access data."  |  
                                   data_download == "The data is archived here but I can't open the link: https://doi:10.5061/dryad.vk002fn" |
                                   data_download == "The link was unavailable."  |                                                                                                                                                                                                   
                                   data_download == "the results are stored in doc file as supplementary material. The handle.org link with original data mentioned in the data availability statement doesnt work." |                                                                
                                   data_download == "They require FTP (because it is too big?). Institutional repository link not working."  |                                                                                                                                       
                                   data_download == "Not able to find the data" | 
                                   data_download ==   "Yes, but only via copy-paste from the manuscript"
                                   ~ "No",
                                   
                                   data_download == "Dryad data - yes; NCBI GenBank link is broken" |
                                   data_download == "Full data have not been archived according to the BES data archiving policy due to restrictions from the data owners. BUT the author mentions where these data can be downloaded" |                                             
                                   data_download == "One dataset yes (Dryad), other no" |
                                   data_download == "Part of the data is available, but part is available only upon request" |
                                   data_download == "Some data are available through dryad but some data are from the NIH and access is blocked."  |                                                                                                                                 
                                   data_download == "Some data available, other data behind paywall, some data under embargo."   |                                                                                                                                                   
                                   data_download == "Some data can be accessed and downloaded, however some data from institutional repositories are unavailable" |                                                                                                                  
                                   data_download == "Yes for the data on DRYAD" |    
                                   data_download == "Yes, but some data are available upon request."
                                   ~ "Yes, but not all data",
                                   
                                   data_download == "I think yes but they are large genomic files"  |
                                   data_download == "If I had the correct tools to gather raw sequence read data" |
                                   data_download == "yes, but I needed to rename the file because the original was too long for my system"
                                   ~ "Yes",
                                   
                                   data_download == "not applicable since they are in the paper" |
                                   data_download == "prevented from accessing the data bcs of firewall restrictions" |
                                   data_download == "No link to data in Data Availability Statement"  |   
                                   data_download == "The data and script files were 14.9 gb in size so i did not download them" |
                                   data_download == "The data is generated using code (not data file). Code in R (.R file). The code to generate de data works" |                                                                                                                    
                                   data_download == "The data must be produced using an R script" |
                                   data_download == "You can download the .R to recreate the data" 
                                    ~ NA_character_,
                                   
                                   TRUE ~ as.character(data_download))) %>%

  #------------------------------------------------------------------------------------------------------
  # 12. Can you open the data?
  # Data that cannot be downloaded cannot be opened so make this NA
  mutate(data_open = case_when(data_download == "No"  | is.na(data_download) ~ NA_character_,                                                                                               
                               TRUE ~ as.character(data_open))) %>%
  # Several cannot be opened because they are huge files so I have modified the "Maybe if I had the correct software" option
  # to "Needs specific software or too large"
  mutate(data_open = case_when(data_open == "I can load the data into R but it just comes up as a huge 3D array, it's not clear whether this is the intended data format as there are no README instructions"                                                                                                   
                               ~ "Yes",
                               
                               data_open == "At the moment no as the archival site is under maintenance and have disabled uploads and downloads" |                                                                                                                                                               
                               data_open == "Data can be opened, but only after having found the proper repository ( https://figshare.com/projects/Nicholson_etal_2019_CPFLEM/57749 ), which is not itself in the paper (the article only gives the link to the metadata, and the dataset have a different DOI)" |
                               data_open == "Loads the file name into R but doesn't load code" |
                               data_open == "Need login credentials" |
                               data_open == "Opens line of code in R to load the data in the directory, but nothing else"|                                                                                                                                                                                       
                               data_open == "Pop up: We are currently upgrading EnviDat backend. Thank you for your understanding and patience during this time. EnviDat can be accessed in read-only mode. Data download, upload and user data management functionalities will be disabled."                   
                               ~ "No",
                               
                               data_open == "Data are a mixture of text files (which I can open) and folders labelled \"NMR_spectra\" which contain a variety of files and types, some without specified formats (\"documents\"). No information about reading these files is given." |                          
                               data_open == "Dryad = Yes, NCBI = maybe if I had the correct software" |
                               data_open == "For one dataset, no. In Dryad, one version of the dataset is available and the other cannot be downloaded."  |
                               data_open == "I can only access, download and open 1 out of 3 datasets that the Data Availability Statement linked to" |
                               data_open == "Only opened the xlsx, not the dbf"  |
                               data_open == "Some files, but not others"|                                                                                                                                                                                                                                        
                               data_open == "Some of the FlickR links to images work, but others are broken." | 
                               data_open == "Yes for the data bat dataset, but for .tif (lidar) i dont have the correct software" |                                                                                                                                                                              
                               data_open == "Yes for the data on DRYAD" |
                               data_open == "I can open the .xlsx, but  don't have Python for the .npy" |
                               data_open == "Can open .xlsx but not .RDS (don't have correct software)"
                               ~ "Yes, but not all files",
                               
                               # if it isn't available to be downloaded so can't be opened = NA
                               data_open == "Data cannot be accessed as it could not be readily downloaded. I need to send request to authors from OSF account for data access." |                                                                                                                               
                               data_open == "Data is not public" |                                                                                                                                                                                                                                               
                               data_open == "Data not available" |
                               data_open == "DOI not found" |
                               data_open == "No link to data in Data Availability Statement"  |                                                                                                                                                                                                                  
                               data_open == "No, data is not publicly available for confidentiality reasons"|                                                                                                                                                                                                    
                               data_open == "Not able to find the data"  |                                                                                                                                                                                                                                       
                               data_open == "not applicable since they are in the paper" |
                               data_open == "R code provided to produce simulated data. Once run, code produces simulated data." |
                               data_open == "We can preview online, but a server error prevented download" |                                                                                                                                                                                                     
                               data_open == "We can't open them because we can't download them" |
                               data_open == "There are suppose to be in the R package, but I am not sure to find them..." 
                               ~ NA_character_,
                               
                               data_open == "Data is 9.3GB zipped and will not extract to open"  |                                                                                                                                                                                                               
                               data_open == "Dataset is very large (> 2 GB)" |
                               data_open == "Data >346mb.ReadMe reviewed." |
                               data_open == "File size too large" |
                               data_open == "I can download the file, but I need to install the package to load the data" |
                               data_open == "Mos tof the data can be opened except for some which requires specialised software" |
                               data_open == "The compressed data file is 13 GB big. My laptop is slow and doesn't have enough space..." |                                                                                                                                                                        
                               data_open == "The data and script files were 14.9 gb in size so i did not download them" |
                               data_open == "Maybe if I had the correct software" 
                               ~ "Needs specific software or too large", 
                            
                               TRUE ~ as.character(data_open))) %>%

  #-----------------------------------------------------------------------------------------------------------
  # 13. Data formats
  # This one is a horrible mess. Many different file types, and many examples of multiple file types which
  # will need splitting up to make graphs etc. Rather than lumping here I'm just going to correct typos/errors
  # Data that do not have a link cannot be downloaded so you cannot know the file type, so make this NA
  mutate(data_format = case_when(data_link == "No"  | is.na(data_link) ~ NA_character_,                                                                                               
                                 TRUE ~ as.character(data_format))) %>%
  # Individual entry fixes
  # Some people have included code files like Rmd and R - this is the code not the data so I have removed this
  # Rdata == rda, updated all to Rdata
  # and ensured that other file types are separated by ; for consistency.
  # .tif not .tiff
  # .tre not .tr or .tree
  # I've used NA for zip files as this is a compression type not the actual file type
  # A lot of confusion wrt shape files (which can be combined into one category) and sequence data (maybe exclude this?).
  mutate(data_format = case_when(data_format == ".csv/.tsv;" ~ ".csv/.tsv",
                                 data_format == ".csv/.tsv;.doc(x);.pdf;.RDS;.txt;.shp; .tif" ~ ".csv/.tsv;.doc(x);.pdf;.RDS;.txt;.shp;.tif",
                                 data_format == ".csv/.tsv;.doc(x);.txt;.xls(x);.grd, .gri, .r, .rmd" ~ ".csv/.tsv;.doc(x);.txt;.xls(x);.grd;.gri",  
                                 data_format == ".csv/.tsv;.doc(x);.xls(x);.pkl; .png; .jpg; .NEF" ~ ".csv/.tsv;.doc(x);.xls(x);.pkl;.png;.jpg;.NEF",
                                 data_format == ".csv/.tsv;.doc(x);citations, its a meta-analysis of papers" ~ ".csv/.tsv;.doc(x)", 
                                 data_format == ".csv/.tsv;.fasta; .table" ~  ".csv/.tsv;.fasta;.table",
                                 data_format == ".csv/.tsv;.gpkg;cpg;dbf;prj;shp;shx;"  ~ ".csv/.tsv;.gpkg;.cpg;.dbf;.prj;.shp;.shx",  
                                 data_format == ".csv/.tsv;.grd; .rda" ~ ".csv/.tsv;.grd;.Rdata",
                                 data_format == ".csv/.tsv;.mat.m" ~ ".csv/.tsv;.mat", 
                                 data_format == ".csv/.tsv;.md" ~ ".csv/.tsv",
                                 data_format == ".csv/.tsv;.mp4, .mat, .jpg" ~ ".csv/.tsv;.mp4;.mat;.jpg", 
                                 data_format == ".csv/.tsv;.pdf;.R" ~ ".csv/.tsv;.pdf", 
                                 data_format == ".csv/.tsv;.pdf;.txt;.cpg, .dbf, .prj, .shp, .xml, .shx, .gpkg, .tif, .sbn, .sbx" ~ ".csv/.tsv;.pdf;.txt;.cpg;.dbf;.prj;.shp;.xml;.shx;.gpkg;.tif;.sbn;.sbx",
                                 data_format == ".csv/.tsv;.pdf;rmd" ~ ".csv/.tsv;.pdf",
                                 data_format == ".csv/.tsv;.pdf;rmd" ~ ".csv/.tsv;.pdf",
                                 data_format == ".csv/.tsv;.R" ~ ".csv/.tsv",
                                 data_format == ".csv/.tsv;.R, .md" ~ ".csv/.tsv", 
                                 data_format == ".csv/.tsv;.Rmd" ~ ".csv/.tsv", 
                                 data_format == ".csv/.tsv;.rda" ~ ".csv/.tsv;.Rdata",
                                 data_format == ".csv/.tsv;.RDS;.shp; .shx; .cpg; .tif" ~ ".csv/.tsv;.RDS;.shp;.shx;.cpg;.tif",
                                 data_format == ".csv/.tsv;.RDS;.xls(x);.rda" ~ ".csv/.tsv;.RDS;.xls(x);.Rdata", 
                                 data_format == ".csv/.tsv;.shp, .shx, .dbf" ~ ".csv/.tsv;.shp;.shx;.dbf",  
                                 data_format == ".csv/.tsv;.tif (and associated files), .dbf, .adf, .shp" ~ ".csv/.tsv;.tif;.dbf;.adf;.shp", 
                                 data_format == ".csv/.tsv;.tif, shapefiles (.shp, .dbf,.shx...)" ~ ".csv/.tsv;.tif;.shp;.dbf;.shx", 
                                 data_format == ".csv/.tsv;.tif; .tr" | data_format == ".csv/.tsv;.tree" ~ ".csv/.tsv;.tif;.tre",
                                 data_format == ".csv/.tsv;.txt;.md" ~ ".csv/.tsv;.txt",
                                 data_format == ".csv/.tsv;.txt;.nex; .tre"  ~ ".csv/.tsv;.txt;.nex;.tre",
                                 data_format == ".csv/.tsv;.txt;.png, .xml" ~ ".csv/.tsv;.txt;.png;.xml",
                                 data_format == ".csv/.tsv;.txt;.R" ~ ".csv/.tsv;.txt",
                                 data_format == ".csv/.tsv;.txt;.RData" ~ ".csv/.tsv;.txt;.Rdata",
                                 data_format == ".csv/.tsv;.txt;.sav; .dat" ~ ".csv/.tsv;.txt;.sav;.dat", 
                                 data_format == ".csv/.tsv;.txt;.shp, .jpg, .tif" ~ ".csv/.tsv;.txt;.shp;.jpg;.tif", 
                                 data_format == ".csv/.tsv;.txt;.tiff" ~ ".csv/.tsv;.txt;.tif", 
                                 data_format == ".csv/.tsv;.txt;.shp, .jpg, .tif" ~ ".csv/.tsv;.txt;.shp;.jpg;.tif", 
                                 data_format == ".csv/.tsv;.txt;.xls(x);. tif, .lewis, .inp (multiple data types)"  ~ ".csv/.tsv;.txt;.xls(x);.tif;.lewis;.inp",                                                                                                                                                                                                                                                                                                                                                 
                                 data_format == ".csv/.tsv;.txt;.xls(x);.xml, .png, .R"  ~ ".csv/.tsv;.txt;.xls(x);.xml;.png", 
                                 data_format == ".csv/.tsv;.txt;rdat" ~ ".csv/.tsv;.txt;Rdata", 
                                 data_format == ".csv/.tsv;.xls(x);.fasta, .tre" ~ ".csv/.tsv;.xls(x);.fasta;.tre", 
                                 data_format == ".csv/.tsv;.xls(x);.R" ~ ".csv/.tsv;.xls(x)", 
                                 data_format == ".csv/.tsv;.xls(x);.Rdata, .shp" ~ ".csv/.tsv;.xls(x);.Rdata;.shp", 
                                 data_format == ".csv/.tsv;.xls(x);shapefiles: .cpg, .dbf, .prj, .sbn, .sbx, .shp, .shx, .CPG, .xml, .nex, .tre"~ ".csv/.tsv;.xls(x);.cpg;.dbf;.prj;.sbn;.sbx;.shp;.shx;.CPG;.xml;.nex;.tre",   
                                 data_format == ".csv/.tsv;.xls(x);Some data are not really formatted properly"  ~ ".csv/.tsv;.xls(x)", 
                                 data_format == ".csv/.tsv;7z, but remain in this file type after being unzipped - README states they are GEOTIFF?" ~ ".csv/.tsv;7z",  
                                 data_format == ".csv/.tsv;Actually excepting the README file, all other data file have no defined extension in its name. After raname it to .csv I succesfully opened them"  ~ ".csv/.tsv",                                                                                                                                                                                                  
                                 data_format == ".csv/.tsv;Data can be accessed through an R package, portalr (https://github.com/weecology/portalr), in addition to CSV files stored in the Zenodo repo." ~  ".csv/.tsv",                                                                                                                                                                                                    
                                 data_format == ".csv/.tsv;Data can likely also be accessed through an R package, fwdata, that is used in the archived R scripts." ~ ".csv/.tsv",                                                                                                                                                                                                                                             
                                 data_format == ".csv/.tsv;fastq, oligos"  ~ ".csv/.tsv;.fastq;.oligos",                                                                                                                                                                                                                                                                                                                                      
                                 data_format == ".csv/.tsv;grd; gri" ~  ".csv/.tsv;.grd;.gri" , 
                                 data_format == ".csv/.tsv;It is difficult to say. The repository is huge and it is not easy to say what is data and what is something else. The README (.md) is not really informative, though there seem to be files here and there with a lot of information. In the repository, there are other files that might be data, such as .js or .geojson, but I cannot really say." ~ ".csv/.tsv;Unclear",
                                 data_format == ".csv/.tsv;Microsoft Access Database (accdb)" ~ ".csv/.tsv;.accdb",                                                                                                                                                                                                                                                                                                                  
                                 data_format == ".csv/.tsv;R (entered manually)" ~ ".csv/.tsv",                                                                                                                                                                                                                                                                                                                            
                                 data_format == ".csv/.tsv;Raw sequence reads" ~ ".csv/.tsv",                                                                                                                                                                                                                                                                                                                                  
                                 data_format == ".csv/.tsv;RData, GeoTiff Raster" ~ ".csv/.tsv;.Rdata",
                                 data_format == ".csv/.tsv;Rmd, RData, Rproj" ~ ".csv/.tsv;.Rdata",
                                 data_format == ".csv/.tsv;rocrate" ~ ".csv/.tsv;.rocrate",                                                                                                                                                                                                                                                                                                                                             
                                 data_format == ".csv/.tsv;shape files (.shp, .dbf, ....)" ~ ".csv/.tsv;.shp;.dbf",                                                                                                                                                                                                                                                                                                                     
                                 data_format == ".csv/.tsv;tif" ~ ".csv/.tsv;.tif",                                                                                                                                                                                                                                                                                                                                                 
                                 data_format == ".csv/.tsv;wav" ~ ".csv/.tsv;.wav",                                                                                                                                                                                                                                                                                                                                                 
                                 data_format == ".csv/.tsv;xml" ~ ".csv/.tsv;.xml", 
                                 data_format == ".dat; .m;"  ~ ".dat;.m",                                                                                                                                                                                                                                                                                 
                                 data_format == ".dbf, .prj, .shp, .shx" ~ ".dbf;.prj;.shp;.shx",                                                                                                                                                                                                                                                                                                                                        
                                 data_format == ".doc(x);.txt;.xls(x);.M file" ~ ".doc(x);.txt;.xls(x);.m",                                                                                                                                                                                                                                                                                                                                 
                                 data_format == ".doc(x);.xls(x);mixture of rasters, shape files, docx, xlsx" ~ ".doc(x);.xls(x);.shp",                                                                                                                                                                                                                                                                                                  
                                 data_format == ".fa" ~ ".fasta",                                                                                                                                                                                                                                                                                                                                                           
                                 data_format == ".fas"  ~ ".fasta",                                                                                                                                                                                                                                                                                                                                                         
                                 data_format == ".fasta and .tre" ~ ".fasta;.tre",                                                                                                                                                                                                                                                                                                                                               
                                 data_format == ".fasta/.fastq" ~ ".fasta;.fastq",                                                                                                                                                                                                                                                                                                                                                 
                                 data_format == ".fcsv, .json, .ply, .vtk, .mrb" ~ ".fcsv;.json;.ply;.vtk;.mrb",                                                                                                                                                                                                                                                                                                                                 
                                 data_format == ".JPG"  ~ ".jpg",                                                                                                                                                                                                                                                                                                                                                        
                                 data_format == ".nex;.rda"  ~ ".nex;.Rdata",                                                                                                                                                                                                                                                                                                                                                   
                                 data_format == ".pdf;.print, .stl, .gh" ~ ".pdf;.print;.stl;.gh",                                                                                                                                                                                                                                                                                                                                         
                                 data_format == ".pdf;.xls(x);.jpg, .mp4" ~ ".pdf;.xls(x);.jpg;.mp4",                                                                                                                                                                                                                                                                                                                                      
                                 data_format == ".pdf;.zip, .vcf" ~ ".pdf;.zip;.vcf",                                                                                                                                                                                                                                                                                                                                              
                                 data_format == ".pdf;pdf that contains links to websites (which are the data for this article)"  ~ ".pdf",                                                                                                                                                                                                                                                                              
                                 data_format == ".r" ~ NA_character_,                                                                                                                                                                                                                                                                                                                                                           
                                 data_format == ".R with code to create the data" ~ NA_character_,                                                                                                                                                                                                                                                                                                                              
                                 data_format == ".rda" ~ ".Rdata",                                                                                                                                                                                                                                                                                                                                                          
                                 data_format == ".RData" ~ ".Rdata",                                                                                                                                                                                                                                                                                                                                                      
                                 data_format == ".RData, .jags" ~ ".Rdata;.jags",                                                                                                                                                                                                                                                                                                                                                
                                 data_format == ".RDS;.xml, .adf" ~ ".RDS;.xml;.adf",                                                                                                                                                                                                                                                                                                                                              
                                 data_format == ".Rsave" ~ NA_character_,                                                                                                                                                                                                                                                                                                                                                       
                                 data_format == ".rtf (rich text format)" ~  ".rtf",                                                                                                                                                                                                                                                                                                                                      
                                 data_format == ".shared , .taxonomy, .tree"  ~ ".tre",                                                                                                                                                                                                                                                                                                                                  
                                 data_format == ".shp; .RData"  ~ ".shp;.Rdata",                                                                                                                                                                                                                                                                                                                                                 
                                 data_format == ".shp; .shx; sbx; sbn; prj; dbf; cpg" ~ ".shp;.shx;.sbx;.sbn;.prj;.dbf;.cpg",                                                                                                                                                                                                                                                                                                                          
                                 data_format == ".tab, .py, .rst, .bat, .yml, .smk" ~  ".tab;.py;.rst;.bat;.yml;.smk",                                                                                                                                                                                                                                                                                                                         
                                 data_format == ".tif, .shp" ~ ".tif;.shp",                                                                                                                                                                                                                                                                                                                                                    
                                 data_format == ".tiff and .asc" ~  ".tif;.asc",                                                                                                                                                                                                                                                                                                                                               
                                 data_format == ".txt;.aln, .fa, .nwk" ~ ".txt;.aln;.fasta;.nwk",                                                                                                                                                                                                                                                                                                                                         
                                 data_format == ".txt;.dat, .stl, .cas.gz, .out" ~ ".txt;.dat;.stl;.cas.gz;.out",                                                                                                                                                                                                                                                                                                                                
                                 data_format == ".txt;.gri; .grd; .tif; .shp"  ~ ".txt;.gri;.grd;.tif;.shp",                                                                                                                                                                                                                                                                                                                                 
                                 data_format == ".txt;.R" ~ ".txt",                                                                                                                                                                                                                                                                                                                                                      
                                 data_format == ".txt;.R; .jpg; .gif; .Rd; .grd; .gri; .rda" ~ ".txt;.jpg;.gif;.grd;.gri;.Rdata",                                                                                                                                                                                                                                                                                                                  
                                 data_format == ".txt;.R; .py; .png" ~ ".txt;.py;.png",                                                                                                                                                                                                                                                                                                                                           
                                 data_format == ".txt;.RData" ~ ".txt;.Rdata",                                                                                                                                                                                                                                                                                                                                                 
                                 data_format == ".txt;.tiff -- all files (including .txt) are related to LANDIS" ~  ".txt;.tif",                                                                                                                                                                                                                                                                                               
                                 data_format == ".txt;.xls(x);" ~ ".txt;.xls(x)" ,                                                                                                                                                                                                                                                                                                                                               
                                 data_format == ".txt;.xls(x);.rda, .Rproj, .Rd" ~ ".txt;.xls(x);.Rdata",                                                                                                                                                                                                                                                                                                                                
                                 data_format == ".txt;.xls(x);Microsoft Access Table Shortcut" ~ ".txt;.xls(x)",                                                                                                                                                                                                                                                                                                                  
                                 data_format == ".txt;.xls(x);multiple formats for sequence data" ~ ".txt;.xls(x)",                                                                                                                                                                                                                                                                                                            
                                 data_format == ".txt;.xls(x);RNA sequence reads" ~ ".txt;.xls(x)",                                                                                                                                                                                                                                                                                                                              
                                 data_format == ".txt;packed in a .rar file" ~ ".txt",                                                                                                                                                                                                                                                                                                                                    
                                 data_format == ".txt;R"  ~ ".txt",                                                                                                                                                                                                                                                                                                                                                      
                                 data_format == ".txt;Rda" ~ ".txt;Rdata",                                                                                                                                                                                                                                                                                                                                                     
                                 data_format == ".txt;See answer to Q6" ~ ".txt",                                                                                                                                                                                                                                                                                                                                         
                                 data_format == ".txt;shapefiles (.shp etc.)" ~ ".txt;.shp",                                                                                                                                                                                                                                                                                                                                    
                                 data_format == ".xls(x);.R"  ~ ".xls(x)",                                                                                                                                                                                                                                                                                                                                                  
                                 data_format == ".xls(x);.RData" ~ ".xls(x);.Rdata",                                                                                                                                                                                                                                                                                                                                                
                                 data_format == ".xls(x);.tif (lidar)" ~ ".xls(x);.tif",                                                                                                                                                                                                                                                                                                                                        
                                 data_format == ".xls(x);.tr" ~ ".xls(x);.tre",                                                                                                                                                                                                                                                                                                                                                    
                                 data_format == ".xls(x);fastq.gz (raw sequencing data)" ~ ".xls(x);fastq.gz",                                                                                                                                                                                                                                                                                                                         
                                 data_format == ".xls(x);Genbank format for DNA sequence" ~ ".xls(x)",                                                                                                                                                                                                                                                                                                                      
                                 data_format == ".xls(x);Images on FlickR" ~ ".xls(x);.jpg",                                                                                                                                                                                                                                                                                                                                     
                                 data_format == ".xls(x);NCBI metagenome PRJNA550037" ~ ".xls(x)",                                                                                                                                                                                                                                                                                                                           
                                 data_format == ".xls(x);SH" ~ ".xls(x)",                                                                                                                                                                                                                                                                                                                                                   
                                 data_format == ".xls(x);SRA archive data (can be read as .fastq, etc.)"  ~ ".xls(x);.fastq",                                                                                                                                                                                                                                                                                                       
                                 data_format == ".xml, .mzTab, .tsv, .mzxml" ~ ".xml;.mzTab;.tsv;.mzxml",                                                                                                                                                                                                                                                                                                                                   
                                 data_format == ".zip, .md" ~ NA_character_,                                                                                                                                                                                                                                                                                                                                                    
                                 data_format == "COCO Image Annotation Format; .jpg; .png" ~ ".jpg;.png",                                                                                                                                                                                                                                                                                                                     
                                 data_format == "Data not available"  ~ NA_character_,                                                                                                                                                                                                                                                                                                                                           
                                 data_format == "Data was mislead archieved as a R script (.R)"  ~ NA_character_,                                                                                                                                                                                                                                                                                                                
                                 data_format == "dataframe in r" ~ NA_character_,                                                                                                                                                                                                                                                                                                                                                
                                 data_format == "Described in Figure 3, and text in section 2.3"  ~ NA_character_,                                                                                                                                                                                                                                                                                                               
                                 data_format == "Downloadable as .csv and .xlsx, but primarily in a database online" ~ ".csv/.tsv;.xls(x)",                                                                                                                                                                                                                                                                                            
                                 data_format == "embedded in the .R code files" ~ NA_character_,                                                                                                                                                                                                                                                                                                                                 
                                 data_format == "Fasta" ~ ".fasta",                                                                                                                                                                                                                                                                                                                                                         
                                 data_format == "fastq.gz" ~ ".fastq.gz",                                                                                                                                                                                                                                                                                                                                                      
                                 data_format == "FASTQ/FASTA" ~ ".fastq;.fasta",                                                                                                                                                                                                                                                                                                                                                   
                                 data_format == "GIS shape files (.dbf, .shp, .prj, .sbx, .CPG, .sbn, .shx)" ~ ".dbf;.shp;.prj;.sbx;.CPG;.sbn;.shx",                                                                                                                                                                                                                                                                                                    
                                 data_format == "gz" ~ ".gz",                                                                                                                                                                                                                                                                                                                                                           
                                 data_format == "he data is generated using code (not data file). Code in R (.R file). The code to generate de data works" ~ NA_character_,                                                                                                                                                                                                                                                      
                                 data_format == "In the package (test data from previous studies)" ~ NA_character_,                                                                                                                                                                                                                                                                                                              
                                 data_format == "it's an R file" ~ NA_character_,                                                                                                                                                                                                                                                                                                                                                
                                 data_format == "jpg" ~ ".jpg",                                                                                                                                                                                                                                                                                                                                                          
                                 data_format == "jpg. and mat." ~ ".jpg;.mat",                                                                                                                                                                                                                                                                                                                                                 
                                 data_format == "Lots of uncommon file types... cpg, dbf, prj, sbn, sbx, shp, shx" ~ ".cpg;.dbf;.prj;.sbn;.sbx;.shp;.shx",                                                                                                                                                                                                                                                                                             
                                 data_format == "not applicable since they are in the paper" ~ NA_character_,                                                                                                                                                                                                                                                                                                                    
                                 data_format == "online sequence" ~ NA_character_,                                                                                                                                                                                                                                                                                                                                               
                                 data_format == "Plain text files without a file extension. Some compressed as tar.xz" ~ ".txt",                                                                                                                                                                                                                                                                                         
                                 data_format == "png" ~ ".png",                                                                                                                                                                                                                                                                                                                                                       
                                 data_format == "R data file" ~ ".Rdata",                                                                                                                                                                                                                                                                                                                                                  
                                 data_format == "R Workspace" ~ NA_character_,                                                                                                                                                                                                                                                                                                                                                   
                                 data_format == "raw sequence reads"  ~ NA_character_,                                                                                                                                                                                                                                                                                                                                           
                                 data_format == "Raw sequence reads" ~ NA_character_,                                                                                                                                                                                                                                                                                                                                            
                                 data_format == "rda" ~ ".Rdata",                                                                                                                                                                                                                                                                                                                                                           
                                 data_format == "Rdata" ~ ".Rdata" ,                                                                                                                                                                                                                                                                                                                                                         
                                 data_format == "RData" ~ ".Rdata",                                                                                                                                                                                                                                                                                                                                                         
                                 data_format == "rwl" ~ ".rwl",                                                                                                                                                                                                                                                                                                                                                            
                                 data_format == "See above" ~ NA_character_,                                                                                                                                                                                                                                                                                                                                                     
                                 data_format == "software, including .exe" ~ NA_character_,                                                                                                                                                                                                                                                                                                                                      
                                 data_format == "Table in the manuscript"  ~ NA_character_,                                                                                                                                                                                                                                                                                                                                      
                                 data_format == "The data must be produced using an R script" ~ NA_character_,                                                                                                                                                                                                                                                                                                                   
                                 data_format == "The paper developed a new R package: .rda .R .rd"  ~ NA_character_,                                                                                                                                                                                                                                                                                                             
                                 data_format == "there is no data archive, just the links to the public online databases" ~ NA_character_,                                                                                                                                                                                                                                                                                       
                                 data_format == "unclear" ~ "Unclear",                                                                                                                                                                                                                                                                                                                                                       
                                 data_format == "unclear what format the data is in."  ~ "Unclear",                                                                                                                                                                                                                                                                                                                          
                                 data_format == "unclear, since access is restricted and subject to request." ~ NA_character_,                                                                                                                                                                                                                                                                                                   
                                 data_format == "Unclear, the DOI is dysfunctional" ~ NA_character_,                                                                                                                                                                                                                                                                                                                             
                                 data_format == "unknown" ~ "Unclear",                                                                                                                                                                                                                                                                                                                                                      
                                 data_format == "Unknown" ~ "Unclear",                                                                                                                                                                                                                                                                                                                                                       
                                 data_format == "unknown, DOI was incorrect"  ~ NA_character_,                                                                                                                                                                                                                                                                                                                                  
                                 data_format == "unnamed data format"  ~ "Unclear",                                                                                                                                                                                                                                                                                                                                         
                                 data_format == "unsure" ~ "Unclear",                                                                                                                                                                                                                                                                                                                                                       
                                 data_format == "Unsure" ~ "Unclear",                                                                                                                                                                                                                                                                                                                                                       
                                 data_format == "UNSURE" ~ "Unclear",                                                                                                                                                                                                                                                                                                                                                     
                                 data_format == "Unsure because could not download" ~ NA_character_,                                                                                                                                                                                                                                                                                                                            
                                 data_format == "wav and wav.data" ~ ".wav",                                                                                                                                                                                                                                                                                                                                             
                                 data_format == "yml, zip"~ NA_character_,                                                                                                                                                                                                                                                                                                                                                     
                                 data_format == "zip file (8.39 GB), downloads fine, won't open \"error 79\"" ~ NA_character_,
                                 data_format == ".zip" ~ NA_character_,
                                 TRUE ~ as.character(data_format))) %>%

  #------------------------------------------------------------------------------------------------------
  # 14. Does the data have a README?
  # Options can be condensed to existing Yes/Mo options. Some confusion where something like a README is
  # provided but it is not called a README. Mostly these are short descriptions, not full READMEs. I have created
  # a new option: "Quasi-README" to express these options where there is something like a README but incomplete.
  # If the README cannot be opened this is the equivalent of having no README.
  # I have not split this to distinguish whether there are READMEs for all files as the README scale Q should 
  # help with this.
  mutate(data_README = case_when(data_README == "A file called README is present - but it's just the abstract" |
                                 data_README == "Can't see one" |
                                 data_README == "It is there but uses WinAnsiEncoding so can't read it" |                                 
                                 data_README == "Not in Dryad page, unsure if it is in file, as I couldn't access" |
                                 data_README == "The provide what they call Original FGDC Metadata, but this is not the data dictionary / metadata of the actual dataset (.csv) that they provide and presumably used for all analyses. I am therefore considering here that there is no REAMDE/metadata" |
                                 data_README == "There is a readme on the Creation of a REST API, but not the data." |
                                 data_README == "Yes- unable to open file" |
                                 data_README == "Yes, but unable to open" 
                                 ~ "No",
                                 
                                 data_README == "A short description has been given in the \"Usage Notes\" within the Dryad landing page."|
                                 data_README == "A short description is included in the Figshare landing page" |                                 
                                 data_README == "A short description is provided on the Figshare page." |
                                 data_README == "A tab in the excel file containing the data has a brief description of what the column headers mean" |
                                 data_README == "Brief method and usage notes section" |
                                 data_README == "available as the repository landing page, but not as a file" |
                                 data_README == "I feel it is important to note that the data has metadata but not a README or a data dictionary/codebook. The metadata provided is perfect, but since there is no README or data dictionary, I decided not to answer question 9." |
                                 data_README ==   "Data was described in the 'Usage notes' section of DRYAD, but no individual README/metadata file"  |                                                                                                                                                             
                                 data_README == "Dataset is described in the Zenodo webpage, but there is not an individual README/metadata file"  |                                                                                                                                                              
                                 data_README == "Description in the zenodo" |                                                                                                                                                                                                                                     
                                 data_README == "Descriptions directly on the dryad webpage" |                                                                                                                                                                                                                    
                                 data_README == "directly on the webpage (e.g. : \"usage notes\")"  |                                                                                                                                                                                                             
                                 data_README == "Has a file with the codes used for species but not called README/metadata and does not contain full information" |                                                                                                                                               
                                 data_README == "it doesn't have a propre doc file Read me, but the webpage on dryad has a short part called \"Usage notes\" which descrbies both sheets on the .xlsx file."  |                                                                                                   
                                 data_README == "Kind of - not a separate file, but there are some details on the first sheet of the .xlsx and brief info on the main zenodo page"   |                                                                                                                            
                                 data_README == "Metadata tab in excel file. Brief description of data, not an indiviual README/metadata file" |                                                                                                                                                                  
                                 data_README == "minimal usage note on dryad"   |                                                                                                                                                                                                                                 
                                 data_README == "No formal README/metadata, but Figshare webpage has brief metadata (treated as metadata for purposes of Q9)" |                                                                                                                                                   
                                 data_README == "No individual README/metadata file, usage notes contain a very brief description of the data file"  |                                                                                                                                                            
                                 data_README == "No README is available, but the description of the data has been provided in the \"Usage Notes\" section of the DRYAD landing page."|                                                                                                                            
                                 data_README == "No Readme or metadata file but description of the data in the section Usage notes in Dryad" |                                                                                                                                                                    
                                 data_README == "No README, but there are simple descriptions of each Excel file on a separate spreadsheet"  |                                                                                                                                                                    
                                 data_README == "No readme, but there is metadata on Dryad"   |                                                                                                                                                                                                                   
                                 data_README == "No separate README file. Description of the columns/headeres are directly available in the Zenodo page."   |                                                                                                                                                    
                                 data_README == "not a formal README file, on webpage"   |                                                                                                                                                                                                                        
                                 data_README == "Not a specific file, but there is a description on figshare" |
                                 data_README == "Not separated file. In \"Usage notes\" section in Dryat"  |                                                                                                                                                                                                      
                                 data_README == "Read \"Usage notes\" on the dryad page"  |                                                                                                                                                                                                                       
                                 data_README == "Repository page contains metadata, while each data file has a twin file containing \"explanation of column names\"" |                                                                                                                                            
                                 data_README == "Some descriptions of the data files are in the 'Method' section of DRYAD, but there is not an individual README/metadata file" |                                                                                                                                 
                                 data_README == "Some information included within the Excel file itself."   |                                                                                                                                                                                                     
                                 data_README == "Supplementary  Info PDF" |                                                                                                                                                                                                                                       
                                 data_README == "The .xlsx data file includes a legend but there is no README or metadata." |
                                 data_README ==   "Has a data dictionary"|                                                                                                                                                                                                                                         
                                 data_README == "Has a data ditctionary" |
                                 data_README == "The data description is included in the Usage Notes section, not as a separate README file." |                                                                                                                                                                   
                                 data_README == "The usage notes section in DRYAD describes the data files, no individual README/metadata file" |                                                                                                                                                                 
                                 data_README == "There are methods and usage notes available on the main Dryad page; no downloadable or obvious readme"  |                                                                                                                                                        
                                 data_README == "There are usage notes in the Dryad repository that are a kind of readme" |
                                 data_README == "there is just a file 'MANIFEST.txt' which lists all files but nothing else" |
                                 data_README == "There is no ReadMe file but the contents that would be in one are written on the website."|
                                 data_README == "Usage notes section in DRYAD provides brief descriptions of each file. No individual README/metadata file." |                                                                                                                                                    
                                 data_README == "user notes on excel file" |                                                                                                                                                                                                                                      
                                 data_README == "Very brief description of the data provided in Figshare. Metadata spreadsheet tab available in each excel file"|                                                                                                                                                 
                                 data_README == "Yes, but only what is provided on the repository webpage (no designated README/metadata file)"|                                                                                                                                                                  
                                 data_README == "Yes? Only the Dryad webpage, no separate README/metadata file. Dryad webpage considered to be metadata for Q9." 
                                 ~ "Quasi-README",
                                
                                 data_README == "Multiple README files (4 Readme)"|
                                 data_README == "Not as a separate document but as a sheet of the excel file" |
                                 data_README == "Read Me is a seperate tab on datasheet which is uninformative, but it has metadata description on zenodo"| 
                                 data_README == "README is merged for code + data, way less useful for data." |
                                 data_README == "The data appears to be stored in different repositories/URLs. The GitHub data has a Readme file, but the data stored in institutional repositories does not have a Readme file per se (it has some information in the repository, but it is not very detailed)."|
                                 data_README == "The file called 'README' is actually the R script with a few notes of metadata interspersed" |                                                                                                                                                                   
                                 data_README == "The file called README is actually a vignette, it does not explain the data" |
                                 data_README == "The README is for the entire repository, which includes both the data and the code" |
                                 data_README == "The README only consists of the sentence \"If you have more questions or want to use this dataset, Please contact Dr. Guiyao Zhou (jdzhouguiyao@163.com)\" so I don't want to count it" |                                                                         
                                 data_README == "there are two data repositories linked. Only one has a README file" |
                                 data_README == "There is a README, but language primarily refers to code not data. Only information relevant to data is author contact details. There is some other metadata on the Dryad page, which I also considered in Q9." |                                                
                                 data_README == "There is an explicit README + some additional metadata on Dryad webpage (i.e. contact details, license details): I considered both for purposes of Q9."  |                                                                                                       
                                 data_README == "Yes for the data on DRYAD" |
                                 data_README == "Yes, for the data used to parameterize the model, but no for the outputs of the individual based simulation." | 
                                 data_README == "Yes. Also considered information on Dryad webpage for purposes of Q9 (e.g. license info is only on the Dryad webpage, not in the designated README)"  |                                                                                                          
                                 data_README == "Yes. Designated README + I also considered information on Dryad webpage as metadata for Q9."  |                                                                                                                                                                  
                                 data_README == "Yes. Explicit README + info on Dryad webpage. Both considered for Q9."    |                                                                                                                                                                                      
                                 data_README == "Yes. Explicit README + metadata on archive webpage (https://conservancy.umn.edu/items/6a8ef2c3-211d-4d2b-bc0e-ee5bf5227909) both considered for Q9."
                                  ~ "Yes",
                                 
                                 data_README == "Data not available" |
                                 data_README == "The link to the data does not open." |                                                                                                                                                                                                                           
                                 data_README == "The link was unavailable."  |                                                                                                                                                                                                                                    
                                 data_README == "The methods section" 
                                 ~ NA_character_,
                                 
                                 TRUE ~ as.character(data_README))) %>%
  
  #------------------------------------------------------------------------------------------------------
  # 15. How useful is the README?
  # Data without a README cannot be scored so make this NA
  mutate(data_README_scale = case_when(data_README == "No"  | is.na(data_README) ~ NA_character_,                                                                                               
                             TRUE ~ as.character(data_README_scale))) %>%
  # This is a scale of 1-10 so needs to be numeric
  mutate(data_README_scale = as.numeric(data_README_scale)) %>%
  #------------------------------------------------------------------------------------------------------
  # 16. How complete is the data?
  # If we can't open the data we can't check this so make these NA
  mutate(data_completeness = case_when(data_open == "No"  | is.na(data_open) ~ NA_character_,                                                                                               
                                       TRUE ~ as.character(data_completeness))) %>%
  # The options here have long descriptions so let's recode them first.
  # Low: The main analyses of the paper cannot be repeated with the data that has been archived.
  # Fair: Some analyses can be repeated but not all (~50% of analyses can be repeated).
  # High: Most data are provided with only small omissions, for example exploratory analyses (~75% of analyses can be repeated).
  # Complete: All the data necessary to reproduce all analyses and results are archived.
  mutate(data_completeness = case_when(data_completeness == "The main analyses of the paper cannot be repeated with the data that has been archived." ~ "Low",
                                       data_completeness == "Some analyses can be repeated but not all (~50% of analyses can be repeated)." ~ "Fair",
                                       data_completeness == "Most data are provided with only small omissions (~75% of analyses can be repeated)." ~ "High",
                                       data_completeness == "All the data necessary to reproduce all analyses and results are archived." ~ "Complete",
                                       TRUE ~ as.character(data_completeness))) %>%
  # This was a difficult variable to assess, so many of these options are just changed to Unsure
  # Where people couldn't access the data I've just gone for unsure. These may end up becoming NAs.
  mutate(data_completeness = case_when(data_completeness == "\"Agreements for these data with partner governements (Kitasoo/Xai'xais and Gitga'at First Nation) prohibit us from diplaying the exact spatial data of detected bears. As such, bear detection information has been summarized at the scale of 'landmass' (see manuscript). Contact the lead author for further information.\"" |
                                       data_completeness == "According to ethical requirements data is available only upon request to the authors." |
                                       data_completeness == "Data included but recoded to hide sensible information" |
                                       data_completeness == "No raw data included, only summaries" |                                                                                                                                                                                                                                                                                                                                       
                                       data_completeness == "Not providing raw data" |
                                       data_completeness == "Mostly summaries"  
                                       ~ "Low",
                                       
                                       data_completeness == "\"A CSV file mentioned in the README is missing, which prevents reproducing the temporal analysis." |
                                       data_completeness == "Data are from camera traps, animal observation frequencies are given but no images from cameras (and no sense of uncertainty)" |
                                       data_completeness == "Data they collected themselves is archivedproperly, qualitative data from workshop findings is in supplementary, public data they used is not archived, just links to gov.uk given" |  
                                       data_completeness == "Simulated data can be recreated, only a smaller example is already archived."| 
                                       data_completeness == "Some part of the raw data was missing to reproduce the analysis. Trait data was submitted but phylogeny used in the analysis is missing."                                                                                                                                                                                                                                   
                                       ~ "Fair",
                                       
                                       data_completeness == "Archived data covers part of the analyses, but the remaining analyses use data within R packages, so they're still reproducible." | 
                                       data_completeness == "Data available is not the raw data but processed. Even so, not sure if the archived data can repeat all of the results in the paper." |
                                       data_completeness == "Empirical data are complete but simulated data are not provided" |
                                       data_completeness == "I believe all the data necessary to reproduce all analyses and results are archived; however, the column headers are French, which I had to translate." |
                                       data_completeness == "Only processed data (no raw data), but this can reproduce all analyses and results." |                                                                                                                                                                                                                                                                                        
                                       data_completeness == "Only processed data (no raw data), but this reproduces all analyses and results." | 
                                       data_completeness == "The data available were processed. Those files can be used to produce all the results, but the raw data to reach the version archived is not shared." |                                                                                                                                                                                                                       
                                       data_completeness == "The data available were processed. Those files can be used to produce all the results, but the raw data to reach the version archived is not shared."                                                                                                                                                                                                                        
                                       ~ "High",
                                       
                                       data_completeness == "All data is provided but not all data is mentioned in the data availability statement - climate data." |
                                       data_completeness == "I believe all the data necessary to reproduce all analyses and results are archived; however, the column headers are French, which I had to translate." |
                                       data_completeness == "All the analyses in the paper can be reproduced, but that is because the paper is missing part of its own method: it does not say how the plant species were sampled, so it is unclear whether each species had multiple replicates (which is missing from the data, with just a single row per species) or if they genuinely only sampled one individual plant per species." |
                                       data_completeness == "All the data necessary to reproduce all analyses and results are archived - except for some of the raw data (e.g. Rsample), but these can be back-calculated if needed from provided data"                                                                                                                                                                                   
                                       ~ "Complete",
                                       
                                       data_completeness == "data but no code" |
                                       data_completeness == "\"Unsure\" applies here. Explanation: The data folder contains many files in various formats, some of which I cannot open. The README is not informative, so assessing the completeness of the archived data is virtually impossible without running all the code." |                                                                                                         
                                       data_completeness == "\"Unsure\" applies here. Explanation: The data folder contains many files in various formats, some of which I cannot open. There is also no accompanying metadata, so assessing the completeness of the archived data is virtually impossible without running all the code." |                                                                                                
                                       data_completeness == "\"Unsure\" applies here. Explanation: there is a large dataset, but no metadata, so assessing the completeness of the archived data is virtually impossible without running all the code."  |                                                                                                                                                                                 
                                       data_completeness == "Aside from genetic dataset archived in NCBI, the remaining data have only been archived in processed form (no raw data). Not sure if the provided data can reproduce all analyses and results." |
                                       data_completeness == "Data as .txt file and difficult to open and understand" |
                                       data_completeness == "Data seems very complete from the list of filenames, but cannot open due to size and extraction" |
                                       data_completeness == "Essential data available in a table in SOM [besides data at Dryad]" |
                                       data_completeness == "Hard to access completeness because of one link not working. The working links do not provide enough data for all analyses." |
                                       data_completeness == "I cannot open parts of the data, the file type does not work on my computer" |                                                                                                                                                                                                                                                                                                
                                       data_completeness == "I had issues witḥ the encoding of some text files" |                                                                                                                                                                                                                                                                                                                          
                                       data_completeness == "I think all the data required to reproduce the analyses are provided. However, I cannot check the statistical analyses because they used JMP Pro version 11 (SAS Institute) and do not provide code (if such is necessary)" |                                                                                                                                                 
                                       data_completeness == "I think all the requisite data are provided, though I have not checked because the readme does not describe the data structure (so it is hard to tell) and the data need to be analysed using the R package the authors created" |                                                                                                                                         
                                       data_completeness == "I think most can be repeated" |                                                                                                                                                                                                                                                                                                                                               
                                       data_completeness == "I think probably most/all analyses can be reproduced, but the detailed data are in Matlab format, which I cannot re-analyse" |                                                                                                                                                                                                                                                
                                       data_completeness == "I would again think all the raw data is available to perform the analysis but due to lack of meta-data and sample sizes I should look for, I am not sure whether I can assess it directly." |                                                                                                                                                                                 
                                       data_completeness == "I'm not sure - the raw catch data is all provided, however, the authors present a lot of modelling scenarios that require further data from other sources (not provided) and calculations. I believe the parameter calculations for the model are all provided in the supplementary info at the end, so I would lean towards yes for this question, but it is complicated"  | 
                                       data_completeness == "I'm not sure as it is very outside of my field - I think yes, as the lab sample results are published, as are the raw sampling data, but I'm not certain about the mass spectrometry data" |                                                                                                                                                                                  
                                       data_completeness == "It is really difficult for me to judge this because the paper is far out of my field - I think yes; all sequence data is published, and the supporting info contains the data on environmental parameters and such used" |                                                                                                                                                    
                                       data_completeness == "It looks like all data are here, but given no code it's not clear to me whether the main analyses can be repeated." |                                                                                                                                                                                                                                                         
                                       data_completeness == "Unsure - due to unclear metadata making it difficult to match the archived data to the methods in the paper." |                                                                                                                                                                                                                                                               
                                       data_completeness == "Unsure because part of the data cannot be accessed"      |                                                                                                                                                                                                                                                                                                                    
                                       data_completeness == "Unsure but data files are labeled \"sample data\" so definitely incomplete" |                                                                                                                                                                                                                                                                                                 
                                       data_completeness == "unsure but I think if the reads are listed this should cover analyses" |                                                                                                                                                                                                                                                                                                      
                                       data_completeness == "Unsure. The authors do not provide complete metadata, there is no explanation of column, but after reading the M&M of the paper, this might be possible. There is no code, only data." |                                                                                                                                                                                      
                                       data_completeness == "Unsure. They provide data in .mat files which are open with Matlab so I cannot check, but the code seems pretty organised"| 
                                       data_completeness == "Missing file DiamTargetSpp.csv [realized while checking the code]" |                                                                                                                                                                                                                                                                                                          
                                       data_completeness == "No code is listed, so unsure if data is complete. It seems likely to be so however given the details on data collection in the methods." |                                                                                                                                  
                                       data_completeness == "No locations have been included in the csv file, thus I am unsure if the entire analysis can be repeated using the data." |                                                                                                                                                                                                                                                   
                                       data_completeness == "One dataset needs to be requested to access due to large file size" |                                                                                                                                                                                                                                                                                                         
                                       data_completeness == "see above" |  
                                       data_completeness == "The data contains images of trees not seals (paper is about seals) !!!!"  |                                                                                                                                                                                                                                                                                                   
                                       data_completeness == "The data was messy. Wrong extension and no README. Yet, the whole procces seems very straigthfoward and I think I could reproduce the results (even if I don't know what kind of data I'm putting in the code)." |                                                                                                                                                            
                                       data_completeness == "There are instructions on how to get the data from iNaturalist, but it hasn't been archived." |                                                                                                                                                                                                                                                                               
                                       data_completeness == "there are R files associated with the study, but the one file labeled data is empty when it is opened." |                                                                                                                                                                                                                                                                     
                                       data_completeness == "The authors provide site locations with their coordinates, and traits in their dataset, but do not directly provide site descriptions to use as predictors. THese are provided in the paper."   |                                                                                                                                                                             
                                       data_completeness == "Seems to have all the three datasets that would be needed as spreadsheets in excel but no meta-data to understand the columns and no sample sizes to see if all the data is provided" 
                                       ~ "Unsure" ,
                                       
                                       data_completeness == "Data not available" |
                                       data_completeness == "data DOI not found" |
                                       data_completeness == "Kenyan STR profiles are unshareable." |
                                       data_completeness == "Unable to download the data so cannot tell" |
                                       data_completeness == "No link to data in Data Availability Statement" |
                                       data_completeness == "R package" | 
                                       data_completeness == "The paper fulltext is not accessible." |
                                       data_completeness == "The link to the data does not open." |                                                                                                                                                                                                                                                                                                                                        
                                       data_completeness == "The link was unavailable."
                                       ~ NA_character_,
                                       
                                       TRUE ~ as.character(data_completeness))) %>%

  #------------------------------------------------------------------------------------------------------
  # CODE!!!                                                                                                                                                                                       
  #------------------------------------------------------------------------------------------------------
  # 17. Code used?
  # Five papers have NA, but all bar one does use code.
  # Several papers which say No or Unsure actually do have code. Some Unsure do not.
  mutate(code_used = case_when(paper_number == 87 | paper_number == 1236 | paper_number == 1302 | paper_number == 3003 |
                               # errors
                               paper_number == 1104 | paper_number == 1654 | paper_number == 1706 | paper_number == 1912 |
                               paper_number == 2253 | paper_number == 2320 | paper_number == 2556 | paper_number == 7122
                                ~ "Yes",
                               paper_number == 249 | paper_number == 772 | paper_number == 1062 | paper_number == 2498 |
                               paper_number == 4116 | paper_number == 7344 | paper_number == 8091
                               ~ "No", 
                               TRUE ~ as.character(code_used))) %>%    
  # Simplified to Yes/No/Unsure. Unsure where it's not clear, but Yes where the recorder is certain code was
  # used even if it is not mentioned at all in the paper or data availability statement
  mutate(code_used = case_when(code_used == "Some of the analyses probably required some coding but it seems they used interactive software [e.g. mark-recapture in MARK]" |  
                               code_used == "Statistical analyses were performed in spss 22.0" |
                               code_used == "Unsure. They provide this: All statistical computations were carried out using the package Statistica 6.0 (StatSoft©; Version 6; StatSoft Inc., Tulsa, OK, USA)." |                                                        
                               code_used == "Used JMP, which is a statistical analysis tool, not code."  
                               ~ "No",
                               
                               code_used == "Although a software or coding language is not mentioned anywhere in the text, the study conducted statistical analyses, IPMs and simulations - so clearly did use some type of coding software, but failed to mention it." |
                               code_used == "Given the plots seems like have been done in R using ggplot2. But isn't mentioned anywhere else in the whole paper" |
                               code_used ==  "model-based paper. Uses software Maximum Entropy Modelling (Maxent v.3.4.1; Phillips et al., 2006; http://biodiversityinformatics.amnh.org/open_source/maxent/)" |
                               code_used == "They don't say that code was used, but at least some figures were made (most likely) with the R package ggplot." |
                               code_used == "They had to use code to work with the data but is not mentioned in the methodology"  |
                               code_used == "They never mention any code nor any software, but based on their analyses, they must have used code" |
                               code_used ==   "yes, at least to create figures" 
                                ~ "Yes",
                               
                               code_used == "All analyses were performed in Comprehensive Meta-Analysis 3.0 software (Borenstein et al., 2005)." |
                               code_used == "It is not stated which coding language or software has been used to analyze data." |
                               code_used == "The paper aimed to develope a software" |
                               code_used ==   "The paper performs statistical analysis but it does not state which statistical software is used (so it is not possible to know if it is code-based or not)" |
                               code_used == "They create a model, but I am not sure whether code was used or how the model simulations were carried out" |
                               code_used == "They use mixed models, but they do not say whether through code or other types of software that do not use code." |
                               code_used == "They use SAS which could be GUI or code" |                                                                                                                                                                               
                               code_used == "They used MetaWin, figures look R, but unsure" 
                               ~ "Unsure",
                               
                               TRUE ~ as.character(code_used))) %>%

  #------------------------------------------------------------------------------------------------------
  # IF NO CODE ARE USED OR UNSURE IF CODE ARE USED, 
  # ANSWERS FOR ALL OTHER CODE QUESTIONS SHOULD BE NA (EXCEPT CODE ALERT TEXT)
  mutate(code_archived = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_archived))) %>%
  mutate(code_availability = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_availability))) %>%
  mutate(code_link = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_link))) %>%
  mutate(code_archive = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_archive))) %>%
  mutate(code_doi = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_doi))) %>%
  mutate(code_CITATION = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_CITATION))) %>%
  mutate(code_license = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_license))) %>%
  mutate(code_license_type = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_license_type))) %>%
  mutate(code_download = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_download))) %>%
  mutate(code_open = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_open))) %>%
  mutate(code_format = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_format))) %>%
  mutate(code_language = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_language))) %>%
  mutate(code_README = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_README))) %>%
  mutate(code_README_scale = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_README_scale))) %>%
  mutate(code_annotation_scale = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_annotation_scale))) %>%
  mutate(code_vignette = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_vignette))) %>%
  mutate(code_Rpackage_available = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_Rpackage_available))) %>%
  mutate(code_OTHERpackage_available = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_OTHERpackage_available))) %>%
  mutate(code_application_cited = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_application_cited))) %>%
  mutate(code_comments = case_when(code_used == "No" | code_used == "Unsure" ~ NA_character_, TRUE ~ as.character(code_comments))) %>%

  #------------------------------------------------------------------------------------------------------
  # 18. Code archived?
  # One comment is so long it's messing everything else up so immediately replace this with a "Yes"
  mutate(code_archived = case_when(paper_number == 2351 ~ "Yes", TRUE ~ as.character(code_archived))) %>%
  # These can be simplified to Yes or No with a couple of NAs.
  # I've collapsed "No, asserts absence of novel code" to "No
  mutate(code_archived = case_when(code_archived == "Note that the DOI linking to the code was included in the M&M section, but not in the Data availability statement" |
                                   code_archived == "The code is attached as PDF in the supporting information" |
                                   code_archived == "the code is in the data zip file but this is not written in the data accessibility statement" |
                                   code_archived == "The code is technically archived, but it is not described where in the paper." |
                                   code_archived == "Yes, and it's mentioned in the data archiving statement, but the link in the data archiving statement is to the Dryad repository for the data. However, the Dryad repository has a link to the Zenodo repository with the code, under \"Related works\""|
                                   code_archived == "Yes, but it does not really open/work" |                                                                                                                                                                                                               
                                   code_archived == "Yes, but it's not explicitly mentioned in the data archiving statement"  |                                                                                                                                                                              
                                   code_archived == "Yes, but only some code showing how to calculate one variable from some example data and not code to replicate the full analysis."  |                                                                                                                    
                                   code_archived == "yes, even refers to code in the README files and data availability statement, but no R scripts are included in the dryad repository" |                                                                                                                   
                                   code_archived == "Yes, is it in Supporting Iinformation, but without mention it."  |                                                                                                                                                                                       
                                   code_archived == "Yes. It was mentioned in data archiving statement. But not included in the dryad link where raw data was found. Instead codes were found in a seperate Zenodo rep shown in dryad as 'related works'."
                                   ~ "Yes",
                                   
                                   code_archived == "Claims to have code but nothing in repository" |
                                   code_archived == "Code mentioned in the data availability statement but not actually available on the repository it refers to" |
                                   code_archived == "Data availability statement says code is included in the repository but it is not there" |
                                   code_archived == "It has some code for developing a map, but not for reproducing the analysis" |
                                   code_archived ==   "No, asserts absence of novel code" |
                                   code_archived == "No, but makes reference to having code in the data availability statement." |
                                   code_archived == "Packages that were used for the analyses are mentioned but no code is available"|
                                   code_archived == "R codes are mentioned in the README files but no code could be found." |
                                   code_archived == "They did create an R package, and say there is an R script in their data archive, but this R script is missing" |
                                   code_archived == "Unsure because I could not open R scripts they included as data" |
                                   code_archived == "they reference archived/previously published code"   
                                   ~ "No",
                                   
                                   code_archived == "Error: DOI not found" |
                                   code_archived == "Included in the available data"
                                    ~ NA_character_,
                                     
                                   TRUE ~ as.character(code_archived))) %>%

  #------------------------------------------------------------------------------------------------------
  # 19. Code mentioned in data availability statement?
  # I have chose No here where it is available but not explicitly mentioned in the data availability statement
  # These No entries can still have data entered for other code based questions.
  mutate(code_availability = case_when(code_availability == "From Data Availability Statement: \"The codes to perform SBCE probability estimation are available on Zenodo (Louvet, 2020), as well as on a GitHub repository.\"" |
                                       code_availability == "in the Data Availability statement they only talk about the data but they give the link to the code"  |
                                       code_availability == "R package is linked in Data Availability statement" |
                                       code_availability ==  "Source code for the device is archived and mentioned in Data availability statement, code for the statistical analysis is not archived" |
                                       code_availability ==  "Yes - \"analysis scripts\" mentioned"
                                       ~ "Yes",
                                       
                                       code_availability == "Code is described in Readme of files on Dryad" |
                                       code_availability == "Code is not mentioned in the Data Availability statement, but it is linked from the Dryad repo that is mentioned in the Data Availability statement"|
                                       code_availability == "Code is not mentioned, but is archived with data in Zenodo that is described in the data statement." |
                                       code_availability == "Data availability statement mentions only data, but also includes code"|
                                       code_availability == "Described in the archived data in Dyrad" |
                                       code_availability == "It is described in the data ReadMe"|
                                       code_availability == "It is indicated in the readme"| 
                                       code_availability == "It is mentioned in the conclusion section"|
                                       code_availability == "It is not described that code was used, but the code was archived together with the data."|
                                       code_availability == "It's quickly mentioned in the Statement in Dryad" |
                                       code_availability == "No - but it is described in both the Methods and the Supplemental Materials" |                                                                                                                                                                                                             
                                       code_availability == "No - but it is described in the Methods"  |                                                                                                                                                                                                                                            
                                       code_availability == "No - but it is described in the Supplemental Materials" |                                                                                                                                                                                                                                  
                                       code_availability == "No but it is in the dryad digital repository" |                                                                                                                                                                                                                                            
                                       code_availability == "No, but archived data contains a code script" |                                                                                                                                                                                                                                            
                                       code_availability == "No, but data archive page on Dryad linked to a citation by the Zenodo archive for the code."|                                                                                                                                                                                              
                                       code_availability == "No, but I found R scripts with the necessary code within the downloaded data folders"|                                                                                                                                                                                                     
                                       code_availability == "No, code is described in the README file described in the Data Availability statement. Code can only be found in the 'related work' section of the DYRAD link. It is not included as part of the downloaded files in the DYRAD link."|                                                     
                                       code_availability == "No, only part of the code is mentioned in the Methods."  |                                                                                                                                                                                                                                 
                                       code_availability == "Statement at end of introduction explains that new method is available in an R package on GitHub. Scripts to run analyses in the paper are available in the institutional repository but are not mentioned anywhere." |                                                                    
                                       code_availability == "Supplementary Information"|
                                       code_availability == "The author only mentions \"Data are archived in Dryad (https://doi.org/10.5061/dryad.jm63xsjm6)...\" and does not mentioned the code anywhere in the paper, nevertheless, in the repo of the data is the R Markdown file with very detailed steps and metadata to reproduce all analyses." |
                                       code_availability == "The code files are contained within the same zip folder as the data"   |                                                                                                                                                                                                                   
                                       code_availability == "The code was deposited in a separate repository and it cites the data, but there was not evident mention of it"|                                                                                                                                                                          
                                       code_availability == "The presence of the code is announced in the methods section: ‘A Markdown file documenting the step-by-step analytical process is uploaded as supplementary information (Appendix 2).’ However, the code file is present in the supplements."    |                                         
                                       code_availability == "There is code archived for one modelling species in Zenodo (RBQ_full_analysis.R) and there is the R package code in CRAN and Github" |                                                                                                                                                     
                                       code_availability == "They point to code previously published at Mendeley Data" 
                                       ~ "No",
                                       
                                       TRUE ~ as.character(code_availability))) #%>%

  #------------------------------------------------------------------------------------------------------
  # 20. Can you open the link to the code?


sort(unique(clean_data_all$code_link))
                                                                                                                                                                                                      


clean_data_all <-
  clean_data_all %>%
  
                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                    
  [1] "Accessible from the .zip folder in the supporting information"                                                                                                                                                                                               
[2] "Authors' just cited their own package, but the specific code to reproduce their simulation results, etc., was not included."                                                                                                                                 
[3] "Code found in repository with the data, but no mention of this in the manuscript."                                                                                                                                                                           
[4] "Code is archived with the data (but this is not explicitly mentioned in the paper)"                                                                                                                                                                          
[5] "Code is available through the link to the data (Dryad), but the paper makes no mention of code being archived anywhere. So there are no instructions or link explicitly linked to the code. We only found it because we followed the link to the Dryad data."
[6] "Code is bundled with the data but not described separately."                                                                                                                                                                                                 
[7] "Code is included in the data repo"                                                                                                                                                                                                                           
[8] "Code was archived with data."                                                                                                                                                                                                                                
[9] "Data Availability Statement is for version 2 of Dryad, code is in Version 3. So it is findable but not from the statement"                                                                                                                                   
[10] "Error: DOI not found"                                                                                                                                                                                                                                        
[11] "I am able to find the code from the link that leads to the data."                                                                                                                                                                                            
[12] "I can access the R code archived on Zenodo, but not the R scripts for testing hypervolume concentration \"available at ftp://pbil.univ-lyon1.fr/pub/datasets/dray/DiazNature/\""                                                                             
[13] "I found the code because it was archved together with data, but there was no reference in the Data Availability (or equivalent) statement"                                                                                                                   
[14] "I have found the code in the data archive"                                                                                                                                                                                                                   
[15] "I would have missed it if I hadn't checked the supporting material"                                                                                                                                                                                          
[16] "It is linked within Data Availability but it's not clear that the code is there too (along with the data)."                                                                                                                                                  
[17] "It was linked to the data repository"                                                                                                                                                                                                                        
[18] "No"                                                                                                                                                                                                                                                          
[19] "no mention that the code is archived, but present with the data"                                                                                                                                                                                             
[20] "Only the DYRAD link is in the Data Availability statement, but the code is not in the files of that link, but in the 'related work' section of that webpage."                                                                                                
[21] "Part of the code was available (a bioinformatics pipeline for processing genetic data), but the R code used in the article is not available, even though it is mentioned in the Dryad repository README."                                                    
[22] "The code is attached, but I haven't found anywhere that says the code has been archived for analysis."                                                                                                                                                       
[23] "The link in the data archiving statement where the code is supposed to be archived is to the Dryad repository for the data. However, the Dryad repository has a link to the Zenodo repository with the code, under \"Related works\""                        
[24] "the link works, but it looks like they forgot to upload the R scripts"                                                                                                                                                                                       
[25] "There was no reference made to archived code. I just found the R-scripts as part of the archived data."                                                                                                                                                      
[26] "They do not mention the code explicitly, but it is available through the same link referring to the data"                                                                                                                                                    
[27] "Unsure if code is included in R scripts with data"                                                                                                                                                                                                           
[28] "We were able to find this following the link to Data in the Data Availabiility link and we found the code after reading the README file"                                                                                                                     
[29] "Yes"                                                                                                                                                                                                                                                         
[30] "yes, but only by clicking on a link to zenodo within the dryad data repository"                                                                                                                                                                              
[31] "yes, but only dev version on GitHub. Stable version on CRAN no longer available."                                                                                                                                                                            
[32] "Yes. But it was hard to find.Codes were found in a seperate Zenodo rep shown in dryad as 'related works'. Not in the main paper."                                                                                                                            
[33] "Zenodo repository where the code is archived is not provided in the Data Availability statement, but is linked in the Dryad repository that *is* included in the Data Availability statement."                                                               

                                                                                                                                                                                                                                               
                                                                                                                                                                          


naniar::miss_var_summary(raw_data_all)
naniar::vis_miss(clean_data_all)


# Extract data validation paper 2272

dat_valid <- filter(raw_data_questions, paper_number == 2272)

# 
# Final checks
# 

# Remove duplicated papers
# 
# Delete other duplicated papers by deleting the later duplicates
# There should be 12
clean_data_all <- distinct(paper_number, .keep_all = TRUE)

