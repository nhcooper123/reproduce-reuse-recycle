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
                recorder = `1. Who recorded data from this paper? First name and initials only for GDPR reasons. If working in pairs, record both names separated by a comma.`, 
                issues = `1. Did you have any issues recording data for this paper? If yes we will go back and check it for you later.`) 

glimpse(raw_data_all)

# ------------------
# Issues to fix
# --------------------------------------------------------------------------
# Missing details that can easily be added using either paper number or DOI
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
# --------------------------------------------------------------------------
clean_data_all <-
  raw_data_all %>%
  # 1. Paper_number
  # Fix some typos
  mutate(paper_number = str_replace(paper_number, "32770", "3277")) %>%
  mutate(paper_number = str_replace(paper_number, "22272", "2272")) %>%
  # And return paper_number to numeric
  mutate(paper_number = as.numeric(paper_number)) %>%
  # 2. DOI
  # Some people used DOI, some used DOI link. Remove the links
  mutate(doi = str_replace_all(doi, "https://doi.org/", "")) %>%
  mutate(doi = str_replace_all(doi, "http://doi.org/", "")) %>%
  mutate(doi = str_replace_all(doi, "doi.org/", "")) %>%
  mutate(doi = str_replace_all(doi, "https://besjournals.onlinelibrary.wiley.com/doi/", "")) %>%
  # Someone pasted an ORCID, but other details match the paper number so swap for DOI
  mutate(doi = str_replace(doi, "https://orcid.org/0009-0008-2457-8954", "10.1111/1365-2656.13383")) %>%
  # 3. Journal
  # Fix one paper with incorrect journal name
  mutate(doi = str_replace(doi, "Ecology and Evolution", "Methods in Ecology and Evolution")) %>%
  # 4. Data used
  # Two papers have NA for data_used, but then go onto answer data questions so should be Yes
  mutate(data_used = replace_na(data_used, "Yes")) %>%
  # One paper incorrectly states that data was used, fix.
  mutate(data_used = case_when(paper_number == 1603 ~ "No",
                                       TRUE ~ as.character(data_used))) %>%
  # 5. Data mentioned in data availability statement
  # Several people forgot to answer this question. 
  # Checked and answered appropriately.
  mutate(data_availability = case_when(paper_number == 1897 ~ "Yes",
                                       paper_number == 245 ~ "Yes",
                                       paper_number == 346 ~ "Yes",
                                       paper_number == 1132 ~ "Yes",
                                       paper_number == 1595 ~ "Yes",
                                       TRUE ~ as.character(data_availability))) %>%
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
         
# Correcting errors in data archive. Some should have NA here as no data are available. 
# Others are institutional repos not special other things
# ### CHECK THESE NA ONES AS THEY SHOULD NOT SAY DATA IS ARCHIVED
mutate(data_archive_clean = case_when(data_archive == "According to ethical requirements data is available only upon request to the authors." |
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
                                      data_archive ==   "Ecological Archives" |
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
                                      
                                      TRUE ~ as.character(data_archive)))
                                                                                                                                                                                                                                                                                                                                                                                               
 


                            
[26]  
[21]     

which(clean_data_all$data_availability == "Yes" & is.na(clean_data_all$data_archive))
sort(unique(clean_data_all$data_archive_clean))


naniar::miss_var_summary(raw_data_all)
naniar::vis_miss(clean_data_all)


# Data validation 2272

dat_valid <- filter(raw_data_questions, paper_number == 2272)
