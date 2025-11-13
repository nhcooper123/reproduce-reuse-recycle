# Raw summary stats (for supplemental materials)
# NC Nov 2025
# 
# Script 01 doe thorough cleaning of the dataset BUT we might want to have a version without aggregation
# of categories so this script does that. For example in script 01, I combined all CC BY derivative licences
# into one category. If you wanted to know exactly how many of each existed, this script splits them out.
# 
# Prior to running this code I ran a script that tidied and anonymised the recorders. 
# Each unique recorder or set of recorders has a unique recorder_ID number. recorder_ID 151 is NA.
# No other changes were made to the raw data.
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
                data_cited = `13. Has the data been cited (excluding the original paper it was archived for)? You can find this information on the Dryad and Figshare landing pages for the dataset on the right hand side. For other repositories it varies. If you can't find out easily just pick Unsure.`,                           
                data_citations = `14. If yes, how many times?  Enter number or Unclear`,                                                                                                                                                                                                                                                      
                data_cited_notself = `15. Has the data been cited by someone other than the original authors? You can find this by clicking on the citations and looking at the papers that cite the data.`,                                                                                                                                      
                data_citations_notself = `16. If yes, how many times? (excluding the original paper it was archived for) Enter number or Unclear`,
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
                code_cited = `19. Has the code been cited (excluding the original paper it was archived for)? Code = the archived code (not the paper or package).`,
                code_citations = `20. If yes, how many times? (excluding the original paper it was archived for) Enter number or Unclear`,                                                                                                                                                                                                                                                    
                code_cited_notself = `21. Has the code been cited by someone other than the original authors?`,
                code_citations_notself = `22. If yes, how many times? Enter number or Unclear`,
                code_comments = `21. Do you have any other comments about the code? For example for those familiar with these processes, does the code use unit test? Doe it have continuous integration? Does it use docker/other containers?`,
                country_corresponding = `1. Country of corresponding author  (on spreadsheet)`,                                                                                                                                                                                                                                                                 
                country_first = `2. Country of first author. Use their main address on the paper. There may be more than one. We mean the address that is next to their name on the paper, NOT any “current address” that may be added for people who have recently moved institutions.`,                                                    
                georegion_data = `3. What georegion(s) were any novel data used in the paper collected from? Select all that apply. NOTE THIS MEANS DATA THAT WERE PHYSICALLY COLLECTED IN THESE COUNTRIES, DO NOT INCLUDE THINGS WHERE THE AUTHORS USED A DATASET FROM FRANCE BUT DID NOT ACTUALLY GO TO FRANCE TO COLLECT DATA :)`,         
                georegion_author_match = `4. Are any authors (use their main address on the paper) based in the georegion the data were collected from?  Also check the Acknowledgments to see if data labourers from the georegion who are not authors are mentioned there instead.`,
                georegion_data_cited = `17. For any paper(s) citing the data, what georegions are on the authors main addresses (i.e. when doing the work)? Please select all relevant options.`,                                                                                                                                                   
                equity_comments = `Any comments about data equity that these Qs don't cover?`,   
                comments = `2. Any other comments about this paper?`,                                                                                                                                                                                                                                                                   
                recorder_ID, # this column name was already updated when anonymising. 
                issues = `1. Did you have any issues recording data for this paper? If yes we will go back and check it for you later.`) 

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

# --------------------------------------------------------------------------
# More complex fixes
# These proceed one variable at a time. Typos or errors are corrected
# Where "Other" was an option all options have been reviewed and corrected
# or consolidated as appropriate. Categories have not been collapsed (unlike in script 01).