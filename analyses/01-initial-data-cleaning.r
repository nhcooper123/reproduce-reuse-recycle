# Initial data cleaning
# Nov 2025
# ---------------
# Load libraries
# ---------------
library(tidyverse)
library(janitor)

# ------------------
# Read in the data
# ------------------
# Read in raw data
rawdata <- read_csv("raw-data/BES-data-code-hackathon-raw-outputs.csv")

# Exclude 127 rows from test run prior to 12 noon 30th Sept
rawdata <- 
  rawdata %>%
  slice(-(1:127))

# Rename columns to make them easier to deal with
raw_data_questions <-
  rawdata %>%
  dplyr::select(paper_number = `1. Paper number`,
                doi = `2. DOI of paper (please copy paste to avoid errors)`,
                year_published = `3. Year of publication (on spreadsheet)`,
                journal = `4. Journal  (on spreadsheet)`,                                                                                                                                                                                                                                                                              
                article_type = `5. Article type  (on spreadsheet)`,                                                                                                                                                                                                                                                                         
                data = `7. Does the paper have data?`, 
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
                data_cited = `13. Has the data been cited (excluding the original paper it was archived for)? You can find this information on the Dryad and Figshare landing pages for the dataset on the right hand side. For other repositories it varies. If you can't find out easily just pick Unsure.`,                           
                data_citations = `14. If yes, how many times?  Enter number or Unclear`,                                                                                                                                                                                                                                                      
                data_cited_notself = `15. Has the data been cited by someone other than the original authors? You can find this by clicking on the citations and looking at the papers that cite the data.`,                                                                                                                                      
                data_citations_notself = `16. If yes, how many times? (excluding the original paper it was archived for) Enter number or Unclear`,
                comments = `2. Any other comments about this paper?`,                                                                                                                                                                                                                                                                   
                recorder = `1. Who recorded data from this paper? First name and initials only for GDPR reasons. If working in pairs, record both names separated by a comma.`, 
                issues = `1. Did you have any issues recording data for this paper? If yes we will go back and check it for you later.`) 
              
                                                                                                                                                                                                                                                               
raw_equity_questions <-
                  rawdata %>%
                  dplyr::select(paper_number = `1. Paper number`,  
                                [43] "1. Country of corresponding author  (on spreadsheet)"                                                                                                                                                                                                                                                                 
                                [56] "2. Country of first author. Use their main address on the paper. There may be more than one. We mean the address that is next to their name on the paper, NOT any “current address” that may be added for people who have recently moved institutions."                                                    
                                [57] "3. What georegion(s) were any novel data used in the paper collected from? Select all that apply. NOTE THIS MEANS DATA THAT WERE PHYSICALLY COLLECTED IN THESE COUNTRIES, DO NOT INCLUDE THINGS WHERE THE AUTHORS USED A DATASET FROM FRANCE BUT DID NOT ACTUALLY GO TO FRANCE TO COLLECT DATA :)"         
                                [21] "17. For any paper(s) citing the data, what georegions are on the authors main addresses (i.e. when doing the work)? Please select all relevant options."                                                                                                                                                   
                                [42] "4. Are any authors (use their main address on the paper) based in the georegion the data were collected from?  Also check the Acknowledgments to see if data labourers from the georegion who are not authors are mentioned there instead."                                                                
                                [67] "Any comments about data equity that these Qs don't cover?"   
                                [39] "For any paper citing the code, what region is on the First author's main address (i.e. when doing the work)"                                                                                                                                                                                               
                                
                                                                                                                                                                                                                                  
raw_equity_questions <-
  rawdata %>%
  dplyr::select(paper_number = `1. Paper number`,
                doi = `2. DOI of paper (please copy paste to avoid errors)`,
                year_published = `3. Year of publication (on spreadsheet)`,
                journal = `4. Journal  (on spreadsheet)`,                                                                                                                                                                                                                                                                              
                article_type = `5. Article type  (on spreadsheet)`,
                code =  `0.3 Does the paper have archived code?`,
                code_availability = `Is the code archiving described in the Data Availability (or equivalent) statement?`,   
                data_availability_text = `6. Please paste the text of the Data Availability statement here`, 
                code_link =  `2. Are you able to find the code using the link/instructions in the Data Availability (or equivalent) statement?`,                                                                                                                                                                                          
                code_archive = `3. Where are the code archived?`,
                code_doi = `4. Does the code have a DOI?`,
                code_license = `16. Does the code have a license`,                                                                                                                                                                                                                                                                        
                code_license_type =  `17. If yes, what license?`,   
                code_download = `5. Can you download the code?`,                                                                                                                                                                                                                                                                            
                code_open = `6. Can you open the code?`,                                                                                                                                                                                                                                                                              
                code_format = `8. What format is the code in?`,
                code_language = `7. What language is the code written in?`,
                code_README = `9. Does the code have a README?`,                                                                                                                                                                                                                                                             
                code_README_scale = `10. How useful is the README? See the protocol for help with making decisions about this. SKIP THIS Q IF NO README EXISTS.`,
                code_Rpackage_available = `13. If the code is an R Package, and it was previously available on CRAN/Bioconductor (as stated in the Data Availability statement), is it still available? Check this by trying to install it on the most recent version of R. If you don't know how to do this/can't do this choose \"Unable to check\"`,
                code_application_cited = `"18. APPLICATION papers only. How many times has the paper been cited? You can find this on the landing page of the paper.`,
                code_cited = `19. Has the code been cited (excluding the original paper it was archived for)? Code = the archived code (not the paper or package).`,
                code_citations = `20. If yes, how many times? (excluding the original paper it was archived for) Enter number or Unclear`,                                                                                                                                                                                                                                                    
                code_cited_notself = `21. Has the code been cited by someone other than the original authors?`,
                code_citations_notself = `22. If yes, how many times? Enter number or Unclear`,
                comments = `2. Any other comments about this paper?`                                                                                                                                                                                                                                                                   
                recorder = `1. Who recorded data from this paper? First name and initials only for GDPR reasons. If working in pairs, record both names separated by a comma.`) 
                issues = `1. Did you have any issues recording data for this paper? If yes we will go back and check it for you later.`  
            
        
                                                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                    
                [53] "14. If the code is a package in another language (e.g. Python) published on PyPI please put the name of the package here and where it has been deposited we will see if it is still available. If you know how to look this up yourself, please do and mention whether it is still available here (Yes/No)"
                [58] "11. How well is the code annotated? See the protocol for help with making decisions about this."                                                                                                                                                                                                           
                [59] "12. Does the code have a separate vignette with examples of how the code should be used?"                                                                                                                                                                                                                  
                [60] "15. Does the code have a CITATION file?"                                                                                                                                                                                                                                                                   
                [62] "0.1 Does the paper use code?"                                                                                                                                                                                                                                                                              
                [63] "0.2 If the paper uses code, and this is NOT archived (i.e. they mention using R or Python but don't provide any scripts) please copy-paste the text from the paper that alerted you to them using code..."                                                                                                 
                [64] "*Please paste the section of the text that refers to the archived code if this is NOT part of the Data Availability Statement*."                                                                                                                                                                           
                [65] "10. How complete is the archived data?"                                                                                                                                                                                                                                                                    
                [66] "21. Do you have any other comments about the code? For example for those familiar with these processes, does the code use unit test? Doe it have continuous integration? Does it use docker/other containers?"                                                                                             
                [68] "Is the code README the same document as the data README?"   

# ------------------
# Issues to fix
# ------------------
# 1. Some people used DOI, some used DOI link...