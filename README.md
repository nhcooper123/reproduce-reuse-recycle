# reproduce-reuse-recycle

Code and data for MEE paper

Author(s): Natalie Cooper (natalie.cooper@nhm.ac.uk) and the hackathon gang

This repository contains all the data and code used in the [paper](LINK TO BE ADDED), EXCEPT the non-anonymised raw data and the script used to anonymise it.

To cite the paper: 
>  Natalie Cooper and the BES Data and Code Hackathon Group. YEAR. Data- and code-archiving in the British Ecological Society journals: present status and recommendations for future improvements.

To cite this repo: 
>  Natalie Cooper. Data and code for MEE paper v1. TO COMPLETE.

This code is shared under an MIT License.

![alt text](https://github.com/nhcooper123/reproduce-reuse-recycle/raw/main/figures/fig1_summary-journal-year.jpg)

-------
## DATA

### Data collection and processing (in brief)

1. We first assembled a list of papers published in the seven BES journals between 2017 and the end of 2024 from Wiley. These are listed in `raw-data/BES_2015-2024_article_data_2025-09-02.csv`. We used script `00-wrangle-raw-data.R` to clean this, excluding reviews, perspectives, forum articles, commentaries and opinion pieces that rarely have data or code to archive, leaving 8,112 eligible papers in `raw-data/BES-article-metadata-2017-2024_2025-09-29.csv`.

2. Next, data on data- and code-archiving were collected as part of a hackathon event (29-30th September 2025), where 145 (in-person and online) participants randomly selected papers from the 8,112 eligible papers in `raw-data/BES-article-metadata-2017-2024_2025-09-29_.csv`, and then followed a bespoke protocol to collect data from randomly selected subset of papers. The full data collection protocol is in the Supporting Information of the paper and in the `/supporting-information` folder of this repo. In addition, all participants collected data for one common paper (paper number 2272) to explore data recorder variability. This data was then anonymised using script `01_anonymise-recorders.r` to remove participant identities resulting in `raw-data/BES-data-code-hackathon-raw-outputs_ANON_2025-11-16.csv`and `raw-data/fixing-papers-with-issues.csv`. 

3. Finally, the data were cleaned using script `02_initial-data-cleaning.r` described below, to result in datasets `BES-data-code-hackathon-cleaned_2025-12-01.csv` and `data-validation_2025-11-16.csv` which are used in the subsequent analyses. 

### Raw data (`/raw-data`)

*Non-anonymised data are not available here for privacy/GDPR reasons.* 

All datasets use "NA" for missing data.

1. **BES_2015-2024_article_data_2025-09-02.csv**

This dataset contains article data given to us by Wiley. Note that the names of the file suggests data from 2015 onwards were available but in reality only data from 2017 onwards was provided. This is raw data that was provided to us, so it is messier than it would have been if we collected it ourselves (e.g. we would not use DD-Mon-YY format for dates!)

Column headers are as follows:

> * **Journal**. Journal code. Options are: *FEC* = Functional Ecology; *MEE3* = Methods in Ecology and Evolution; *PAN3* = People and Nature; *JANE* = Journal of Animal Ecology; *JEC* = Journal of Ecology; *JPE* = Journal of Applied Ecology; *ESO3* = Ecological Solutions and Evidence.
> * **Article ID**. ID number for paper.
> * **Vol Iss**.	Volume and issue number in format Volume:Issue.
> * **Article Title**. Title of paper. 
> * **Editorial Reference Code**.	Reference code used by editorial office.	
> * **DOI**. Digital object identifier.
> * **DOI Link**.	DOI link to the webpage for the paper.
> * **Submitting Editor**. Senior Editor who handled the paper.
> * **Classification (Base Article Type)**. Paper type using editorial system classifications. Can be ignored to use Category (Display Article Type) instead.	
> * **Category (Display Article Type)**. Paper type using standard names. We selected options: *Research Article*; *Applications*; *Practical Tools*; *Data Articles* and *Long Term Study*. We excluded options: *Biological Flora; Commentary; Concept; Correction; Correspondence; Corrigendum; Editorial; Editorial Note; Erratum; Essay Review; FE Spotlight; Forum; From Practice; Guest Editorial; How To; In Focus; Mini review; Perspectives; Policy Directions; Practice Insights; Practitioner Perspective; Registered Reports; Research Highlights; Research Methods Guides; Review; Review and Synthesis; Synthesis*.
> * **Corresponding Author Country**.	Country for corresponding author. Care needed here as further research showed this was often incorrect (people forget to update ScholarOne so these are often very out of date).
> * **EarlyView Actual**.	Date (DD-Mon-YY) when paper appeared online on Early View.
> * **First Online Actual**. Date (DD-Mon-YY) when paper published online in its final format.

2.  **BES-article-metadata-2015-2024_2025-09-29.csv**

This is the cleaned version of `raw-data/BES_2015-2024_article_data_2025-09-02.csv`. The order of the papers was randomised then each was given a unique paper number. We recommended participants focus on ten consecutively numbered papers at a time so that papers were selected at random.

Column headers are as follows:

> * **paper_number**. The unique paper number.                
> * **doi_link**. Digital object identifier (DOI) link to the webpage for the paper.                      
> * **doi**. Digital object identifier (DOI).                         
> * **journal** Journal. Options are: *Ecological Solutions and Evidence*; *Functional Ecology*; *Journal of Animal Ecology*; *Journal of Applied Ecology*; *Journal of Ecology*; *Methods in Ecology and Evolution*; and *People and Nature*.                          
> * **article_type**. Article type. Options are: *Research Article*; *Applications*; *Practical Tools*; *Data Articles* and *Long Term Study*.                 
> * **article_title**. Title of published paper.               
> * **date_published**. Date the paper was published online in its final format (DD-Mon-YY).                
> * **corresponding_author_country**. Country listed for corresponding author.

3. **BES-data-code-hackathon-raw-outputs_ANON_2025-11-16.csv**

This is the horribly messy raw output from the Google Form we used to collect the data. Each column header is the full question asked in the form, so they are very long and convoluted. The contents of these columns are explained in detail in the data collection protocol which is in the Supporting Information of the paper and in the `/supporting-information` folder in this repo. A list of column headers is near the end of this README (it was too long to include here).

4. **fixing-papers-with-issues.csv**

This dataset contains papers flagged with issues by participants, and the suggested solution to those issues. Options for fixes were either to edit (Edit) the entry for the paper as indicated in this dataset, delete the paper from the final analysis dataset (Delete), delete duplicate papers (Delete duplicate), or no fix recommended (None).

The columns headers are all the same as those in `BES-data-code-hackathon-cleaned_2025-12-01.csv` below except the addition of:

> * **course_of_action**.	What should we do to fix this paper? Options: *Edit; Delete; Delete duplicate; None*.
> * **justification**. Long form text explanation of why the course of action was recommended.

### Processed/cleaned data used in analyses (`/data`)

All datasets use "NA" for missing data.

1.  **BES-data-code-hackathon-cleaned_2025-12-01.csv**

This is the cleaned version of the anonymised dataset (`raw-data/BES-data-code-hackathon-raw-outputs_ANON_2025-11-16.csv`) which we used in the analyses. This dataset contains n = 1,861 papers in total.

Column headers are as follows:

> * **paper_number**. Unique paper number.                
> * **doi**. Digital object identifier (DOI).                          
> * **year_published**. Year the final version was published online (2017-2024)             
> * **journal**. Journal. Options are: *Ecological Solutions and Evidence*; *Functional Ecology*; *Journal of Animal Ecology*; *Journal of Applied Ecology*; *Journal of Ecology*; *Methods in Ecology and Evolution*; *People and Nature*.                     
> * **article_type**. Article type. Options are: *Research Article*; *Applications*; *Practical Tools*; *Data Articles*; *Long Term Study*.                
> * **data_used**. Were data used? Options are: *Yes*; *No*.                   
> * **data_availability**. Are data mentioned in the data availability statement? Options are: *Yes*; *No*; *No, but they are available on request*. Due to the requirement for data archiving this is equivalent to asking "was any data archived?".             
> * **data_availability_text**. Full text from the Data Availability statement. Long form text.     
> * **data_link**. Does the link direct you to the dataset? Options are: *Yes*; *No*.                 
> * **data_archive**. Where are the data archived? Multiple options can be selected. Options are: *Dryad; Figshare; GitHub; GitLab; Codeberg or similar platform; Other repo/database; Personal website; Supplementary materials; Zenodo*.               
> * **data_doi**. Does the data have a DOI? Options are: *Yes*; *No*; *Unsure*; *Yes, but DOI not found/incorrect*; *Yes, but not for all data archived*.                    
> * **data_license**. Does the data have a license? Options are: *Yes*; *No*; *Unsure*; *Yes, but not for all data archived*.              
> * **data_license_type** What type of license does the data have? Multiple options can be selected. Options are: *CC BY; CC BY derivatives; CC0; OGL; Other*. Note that CC BY derivatives means licenses like CC BY-SA.         
> * **data_download**. Can the data be downloaded? Options are: *Yes*; *No*; *No, because the data are embargoed*; *Yes, but not all data*.               
> * **data_open**. Can the data be opened? Options are: *Yes*; *No*; *Needs specific software or too large*; *Yes, but not all files*.                   
> * **data_format**. File extension the data file(s) were saved in. Multiple options can be selected. Options are: *7z*; *.adf*; *.asc*; *.aln*; *.avi*; *.bat*; *.cpg*; *.csv/.tsv*; *.dat*;*.db*; *.dbf*; *.doc(x)*; *.dtg*; *.fasta*; *.fastq*; *fastq.gz*; *.fna*; *.fq*; *.gpkg*; *.gh*; *.grd*; *.gri*; *.gz*; *.html*; *.inc*; *.inp*; *.jags*; *.jpg*; *.js*; *.json*; *.lewis*; *.lux*; *.m*; *.mat*; *.md*; *.mp4*; *.mrb*; *.mzTab*; *.mzxml*; *.NEF*; *.nex*; *.nlogo*; *.numbers*; *.nwk*; *.ods*; *.oligos*; *.pdf*; *.phy*; *.pkl*; *.ply*; *.png*; *.print*; *.prj*; *.py*; *.Rdata*; *.RDS*; *.rocrate*; *.rst*; *.rtf*; *.rwl*; *.sav*; *.sbn*; *.sbx*; *.shp*; *.shx*; *.sqlite*; *.smk*; *.stl*; *.tab*; *.table*; *.tar*; *.tif*; *.tre*; *.txt*; *.vcf*; *.vtk*; *.wav*; *.xlsm*; *.xls(x)*; *.xml*; *.yml*; *.zip*; *Unsure*. Note that these options were collapsed down during the analyses as some are equivalent.                
> * **data_README**. Does the data have a README or equivalent? Options are: *Yes*; *No*; *Unsure*; *Quasi-README*. Quasi-README indicated situations where there was something like a README, but not exactly a README. In our analyses we put this into the Yes category.                
> * **data_README_scale**. How useful is the README or equivalent? This is a scale from 1 to 10 where 1 = very brief and incomplete, and 10 = you can understand the dataset in just a few minutes. Contains all column headers, abbreviations, units, data sources, data dictionary, license info, paper info etc.          
> * **data_completeness**. How complete are the data? This is a four point scale. Options are: *low* = the main analyses of the paper cannot be repeated with the data that has been archived; *fair* = some analyses can be repeated but not all (~50% of analyses can be repeated); *high* = most data are provided with only small omissions, for example exploratory analyses (~75% of analyses can be repeated); *complete* = all the data necessary to reproduce all analyses and results are archived.
          
> * **code_used**. Was code used in the paper? Options are: *Yes*; *No*; *Unsure*.                   
> * **code_alert**. If code is not mentioned in the Data Availability statement, what part of the text alerted you that code was used in the paper? Long form text.                 
> * **code_archived**. Was any code archived? Options are: *Yes*; *No*              
> * **code_availability**. Is code mentioned in the data availability statement? Options are: *Yes*; *No*.             
> * **code_link**. Does the link direct you to the code? Options are: *Yes*; *No*.                 
> * **code_archive**. Where are the data archived? Multiple options can be selected. Options are: *CRAN*; *Dryad; Figshare; GitHub; GitLab; Codeberg or similar platform; Other repo/database; Personal website; Supplementary materials; Zenodo*. 
> * **code_doi**. Does the code have a DOI? Options are: *Yes*; *No*; *Unsure*; *Yes, same as data*.                     
> * **code_license**. Does the code have a license? Options are: *Yes*; *No*; *Unsure*.                
> * **code_license_type**. What type of license does the code have? Multiple options can be selected. Options are: *CC BY; CC BY derivatives; CC0; GPL; MIT; Other; Unsure*. Note that CC BY derivatives means licenses like CC BY-SA.            
> * **code_CITATION**. Does the code have a CITATION file or equivalent? Options are: *Yes*; *No*; *Unsure*.                
> * **code_download**. Can the code be downloaded? Options are: *Yes*; *No*.               
> * **code_open**. Can the code be opened? Options are: *Yes*; *No*; *Maybe if I had the right software*.                   
> * **code_format**. File extension the code file(s) were saved in. Multiple options can be selected. Options are: *.csv/.tsv; .doc(x); .html; native source code; notebook; .pdf; .txt; Other; Unsure*. Native source code includes things like .R, .py and .jl. Notebooks include RMarkdown, Quarto and Jypiter notebooks.
> * **code_language**. What programming language is the code written in? Multiple options can be selected. Options are: *BUGS/JAGS; C/C++; HTML; Java; Julia; Mathematica; MATLAB; NetLogo; Perl; Python; Shell, SQL; Stan; TeX/LaTeX; Other*.                                
> * **code_README**. Does the code have a README or equivalent? Options are: *Yes*; *No*; *Quasi-README*. Quasi-README indicated situations where there was something like a README, but not exactly a README. In our analyses we put this into the Yes category.                               
> * **code_README_scale**. How useful is the README or equivalent? This is a scale from 1 to 10. 1 = very brief and incomplete, and 10 = all information about script functionality, outputs, software, packages, workflows comprehensively documented.           
> * **code_annotation_scale**. How good is the code annotation? This is a scale from 1 to 10. of 1 = not annotated at all and 10 = thorough annotation throughout.       
> * **code_vignette**. Does the code have a vignette or similar examples file/manual? Options are: *Yes*; *No*; *Unsure*.                
> * **code_Rpackage_available**. If the paper presented a new R package, can you still access the package on CRAN or Bioconductor? Options are: *Yes*; *No*; *Not an R package*; *Unable to check*.      
> * **code_application_cited**. Number of times an Applications type paper has been cited. Integer.     
> * **code_comments**. Any additional comments about code reproducibility.              
> * **country_first**. Country/region of first author. Selected from UN M49 standard georegions: https://unstats.un.org/unsd/methodology/m49/#geo-regions.            
> * **comments**. Any comments about the paper.                    
> * **recorder_ID**. Who collected this data? Unique ID number for each recorder or group of recorders.

2. **data-validation_2025-11-16.csv**

This is the cleaned version of `raw-data/BES-data-code-hackathon-raw-outputs_ANON_2025-11-16.csv` subset to only include paper 2272 and used in the recorder variability analyses.

The columns headers are all the same as those in `BES-data-code-hackathon-cleaned_2025-12-01.csv` above.

-------
## Analyses

Analyses were carried out in the following order.

* **00-wrangle-raw-data.R**. 

This preliminary data wrangling script is in the subfolder `prepare-paper-list`.

The first step of the analyses was to take the list of published papers across the BES journals from 2017-2024 and wrangle this data to create a list of papers participants could collect data from. This script cleans the data, removes paper types that are unlikely to share data/code e.g. reviews, randomises the order of papers and assigns each a unique ID called `paper_number` which is used to refer to papers in the rest of the analyses.

This script uses the  `raw-data/BES_2015-2024_article_data_2025-09-02.csv` dataset. It outputs `data/2025-09-29_BES-article-metadata-2015-2024.csv`. Note that the names of these files suggest data from 2015 onwards was available but in reality only data from 2017 onwards was provided by Wiley.

This script also produces the summary numbers/% for the proportion of papers in each journal/year in the full dataset. This forms one part of Table S1, so we can check our papers are broadly representative of the full dataset.

We used this list during the hackathon.

* **01_anonymise-recorders.r**. 
*Note that this script cannot be shared as it contains GDPR sensitive information.*

Next the collected data from the hackathon had to be anonymised due to GDPR legislation. Each unique data recorder (or group of data recorders where people were working as a team) was given a unique recorder ID number, then their names and details were removed from the data.

This script uses `raw-data/non-anonymised-data/BES-data-code-hackathon-raw-outputs.csv` which cannot be shared due to GDPR legislation. It outputs the shareable `raw-data/BES-data-code-hackathon-raw-outputs_ANON.csv`

* **02_initial-data-cleaning.r**.

This script takes the anonymised data collected at the hackthon from `raw-data/BES-data-code-hackathon-raw-outputs_ANON_2025-11-16.csv` and (slowly and painfully!) cleans it so it can be used in the analyses. The script uses `fixing-papers-with-issues.csv` to fix particular issues flagged by participants of the hackathon and followed up on by the organising team. The script then removes excess variables we did not use in the final analyses, standardises write up answers, fixes typos, removes duplicate entries etc. It also selects all entries for paper 2272 which we used to look at data recorder variability and outputs these separately - only one entry for 2272 is retained in the main dataset.

The script outputs `data/BES-data-code-hackathon-cleaned_2025-12-01.csv` and `data/data-validation_2025-11-16.csv`, the processed datasets used in all subsequent analyses.

* **03_summary-stats-plots.qmd**

This script explores the data in `data/BES-data-code-hackathon-cleaned_2025-12-01.csv`, and produces several summary figures and tables. These are for information purposes and not output for use in the paper. Though some numbers calculated appear in the main text.

* **04_figures-for-paper.r**

This script uses `data/BES-data-code-hackathon-cleaned_2025-12-01.csv` to create all the figures used in the paper and some in the supporting information. This script outputs Figures 1-7 and Supporting Figure S16. All figures are output to the `/figures` folder. 

* **05_tables-for-paper.r**

This script uses `data/BES-data-code-hackathon-cleaned_2025-12-01.csv` to extract numbers used in tables in the paper and the supporting information. It also contributes numbers cited in the paper text, for example median scores for README and code annotation quality. This script outputs numbers used in Tables S2-S4, though several tables are combined to create each of these tables. All tables are output to the `/tables` folder.

* **06_by-journal-figures-for-supplemental.r**

This script uses `data/BES-data-code-hackathon-cleaned_2025-12-01.csv` to create all the journal-specific figures used in the supporting information. This script outputs Supporting Figures S1-S14. All figures are output to the `/figures` folder.

* **07_through-time-figures-for-supplemental.r**

This script uses `data/BES-data-code-hackathon-cleaned_2025-12-01.csv` to create figures of the different variables but separated by year published. This no longer forms part of the paper but is included for completeness. All figures are output to the `/figures` folder.

* **08_readmes-by-archive.r**

This script uses `data/BES-data-code-hackathon-cleaned_2025-12-01.csv` to determine whether README quality varies by archive. This no longer forms part of the paper but is included for completeness. All figures are output to the `/figures` folder.

* **09_recorder-variability.r**

This script uses `data/BES-data-code-hackathon-cleaned_2025-12-01.csv` to investigate variability in data recorders by investigating how 100 different data recorders collected data for paper 2272. This script outputs Supporting Figure S15, and the numbers in used in the Supporting Information and main text when describing data recorder variability. The figure is output to the `/figures` folder.

-------
## Other folders

* `/figures` contains all figures for the paper and supporting information.
* `/tables` contains all tables for the paper and supporting information. 
* `/supporting-information` contains the full data collection protocol and the Supporting Information from the paper in PDF format.

-------
## Session Info
For reproducibility purposes, here is the output of `devtools::session_info()` used to perform the analyses in the publication.

    ─ Session info    ─────────────────────────────────────────────────────────────────────────────────────────────────────
    setting  value
    version  R version 4.5.0 (2025-04-11)
    os       macOS Sequoia 15.5
    system   aarch64, darwin20
    ui       RStudio
    language (EN)
    collate  en_US.UTF-8
    ctype    en_US.UTF-8
    tz       Europe/London
    date     2026-03-03
    rstudio  2026.01.1+403 Apple Blossom (desktop)
    pandoc   3.7.0.2 @ /usr/local/bin/pandoc
    quarto   1.8.25 @ /Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto

    ─ Packages ─────────────────────────────────────────────────────────────────────────────────────────────────────────
    package      * version date (UTC) lib source
    bit            4.6.0   2025-03-06 [1] CRAN (R 4.5.0)
    bit64          4.6.0-1 2025-01-16 [1] CRAN (R 4.5.0)
    cachem         1.1.0   2024-05-16 [1] CRAN (R 4.5.0)
    cli            3.6.5   2025-04-23 [1] CRAN (R 4.5.0)
    crayon         1.5.3   2024-06-20 [1] CRAN (R 4.5.0)
    devtools       2.4.6   2025-10-03 [1] CRAN (R 4.5.0)
    dichromat      2.0-0.1 2022-05-02 [1] CRAN (R 4.5.0)
    dplyr        * 1.1.4   2023-11-17 [1] CRAN (R 4.5.0)
    ellipsis       0.3.2   2021-04-29 [1] CRAN (R 4.5.0)
    evaluate       1.0.5   2025-08-27 [1] CRAN (R 4.5.0)
    farver         2.1.2   2024-05-13 [1] CRAN (R 4.5.0)
    fastmap        1.2.0   2024-05-15 [1] CRAN (R 4.5.0)
    forcats      * 1.0.1   2025-09-25 [1] CRAN (R 4.5.0)
    fs             1.6.6   2025-04-12 [1] CRAN (R 4.5.0)
    generics       0.1.4   2025-05-09 [1] CRAN (R 4.5.0)
    ggplot2      * 4.0.0   2025-09-11 [1] CRAN (R 4.5.0)
    glue           1.8.0   2024-09-30 [1] CRAN (R 4.5.0)
    gtable         0.3.6   2024-10-25 [1] CRAN (R 4.5.0)
    here         * 1.0.2   2025-09-15 [1] CRAN (R 4.5.0)
    hms            1.1.3   2023-03-21 [1] CRAN (R 4.5.0)
    janitor      * 2.2.1   2024-12-22 [1] CRAN (R 4.5.0)
    knitr        * 1.50    2025-03-16 [1] CRAN (R 4.5.0)
    lifecycle      1.0.4   2023-11-07 [1] CRAN (R 4.5.0)
    lubridate    * 1.9.4   2024-12-08 [1] CRAN (R 4.5.0)
    magrittr       2.0.4   2025-09-12 [1] CRAN (R 4.5.0)
    memoise        2.0.1   2021-11-26 [1] CRAN (R 4.5.0)
    naniar       * 1.1.0   2024-03-05 [1] CRAN (R 4.5.0)
    patchwork    * 1.3.2   2025-08-25 [1] CRAN (R 4.5.0)
    pillar         1.11.1  2025-09-17 [1] CRAN (R 4.5.0)
    pkgbuild       1.4.8   2025-05-26 [1] CRAN (R 4.5.0)
    pkgconfig      2.0.3   2019-09-22 [1] CRAN (R 4.5.0)
    pkgload        1.5.0   2026-02-03 [1] CRAN (R 4.5.2)
    purrr        * 1.1.0   2025-07-10 [1] CRAN (R 4.5.0)
    R6             2.6.1   2025-02-15 [1] CRAN (R 4.5.0)
    RColorBrewer   1.1-3   2022-04-03 [1] CRAN (R 4.5.0)
    readr        * 2.1.5   2024-01-10 [1] CRAN (R 4.5.0)
    remotes        2.5.0   2024-03-17 [1] CRAN (R 4.5.0)
    rlang          1.1.6   2025-04-11 [1] CRAN (R 4.5.0)
    rprojroot      2.1.1   2025-08-26 [1] CRAN (R 4.5.0)
    rstudioapi     0.17.1  2024-10-22 [1] CRAN (R 4.5.0)
    S7             0.2.0   2024-11-07 [1] CRAN (R 4.5.0)
    scales         1.4.0   2025-04-24 [1] CRAN (R 4.5.0)
    sessioninfo    1.2.3   2025-02-05 [1] CRAN (R 4.5.0)
    snakecase      0.11.1  2023-08-27 [1] CRAN (R 4.5.0)
    stringi        1.8.7   2025-03-27 [1] CRAN (R 4.5.0)
    stringr      * 1.5.2   2025-09-08 [1] CRAN (R 4.5.0)
    tibble       * 3.3.0   2025-06-08 [1] CRAN (R 4.5.0)
    tidyr        * 1.3.1   2024-01-24 [1] CRAN (R 4.5.0)
    tidyselect     1.2.1   2024-03-11 [1] CRAN (R 4.5.0)
    tidyverse    * 2.0.0   2023-02-22 [1] CRAN (R 4.5.0)
    timechange     0.3.0   2024-01-18 [1] CRAN (R 4.5.0)
    tzdb           0.5.0   2025-03-15 [1] CRAN (R 4.5.0)
    usethis        3.2.1   2025-09-06 [1] CRAN (R 4.5.0)
    vctrs          0.6.5   2023-12-01 [1] CRAN (R 4.5.0)
    visdat         0.6.0   2023-02-02 [1] CRAN (R 4.5.0)
    vroom          1.6.6   2025-09-19 [1] CRAN (R 4.5.0)
    withr          3.0.2   2024-10-28 [1] CRAN (R 4.5.0)
    xfun           0.53    2025-08-19 [1] CRAN (R 4.5.0)

    [1] /Users/natac4/Library/R/arm64/4.5/library
    [2] /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/library
    * ── Packages attached to the search path.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

 
## Checkpoint for reproducibility
To rerun all the code with packages as they existed on CRAN at time of our analyses we recommend using the `checkpoint` package, and running this code prior to the analysis:

```{r}
checkpoint("2026-03-02")
```

------------

### Raw data metadata

**BES-data-code-hackathon-raw-outputs_ANON_2025-11-16.csv**

This is the horribly messy raw output from the Google Form we used to collect the data. As such each column header is the full question asked in the form, so they are very long and convoluted. The contents of these columns are explained in detail in the data collection protocol which is in the Supporting Information of the paper and in the `/supporting-information` folder. Numbering refers to questions within subsections of the form, but looks a bit nonsensical without the form for reference.

Column headers are as follows:

> * **Timestamp**. Time that the data was entered into the Google Form.
> * **1. Paper number**
v* **2. DOI of paper (please copy paste to avoid errors)**
> * **3. Year of publication (on spreadsheet)** 
> * **4. Journal  (on spreadsheet)** 
> * **5. Article type  (on spreadsheet)** 
> * **6. Please paste the text of the Data Availability statement here** 
> * **7. Does the paper have data?**
> * **1. Country of corresponding author  (on spreadsheet)**
> * **2. Country of first author. Use their main address on the paper. There may be more than one. We mean the address that is next to their name on the paper, NOT any “current address” that may be added for people who have recently moved institutions.**
> * **3. What georegion(s) were any novel data used in the paper collected from? Select all that apply. NOTE THIS MEANS DATA THAT WERE PHYSICALLY COLLECTED IN THESE COUNTRIES, DO NOT INCLUDE THINGS WHERE THE AUTHORS USED A DATASET FROM FRANCE BUT DID NOT ACTUALLY GO TO FRANCE TO COLLECT DATA :)**
> * **4. Are any authors (use their main address on the paper) based in the georegion the data were collected from?  Also check the Acknowledgments to see if data labourers from the georegion who are not authors are mentioned there instead.**
> * **Any comments about data equity that these Qs don't cover?**
> * **1. Are the data mentioned in the Data Availability statement?**
> * **2. Are you able to find the data using the link/instructions in the Data Availability statement?**
> * **3. Where are the data archived?**
> * **4. Does the dataset have a DOI?**
> * **5. Can you download the data?**
> * **6. Can you open the data?**
> * **7. What format are the data in?**
> * **8. Does the data have a README/metadata?**
> * **9. How useful is the README/metadata? Read the notes in the protocol to help with decisions here. SKIP THIS Q IF NO README EXISTS.**
> * **10. How complete is the archived data?**
> * **11. Does the data have a license?**
> * **12. If yes, what license?**
> * **13. Has the data been cited (excluding the original paper it was archived for)? You can find this information on the Dryad and Figshare landing pages for the dataset on the right hand side. For other repositories it varies. If you can't find out easily just pick Unsure.**
> * **14. If yes, how many times?  Enter number or Unclear**
> * **15. Has the data been cited by someone other than the original authors? You can find this by clicking on the citations and looking at the papers that cite the data.**
> * **16. If yes, how many times? (excluding the original paper it was archived for) Enter number or Unclear**
> * **17. For any paper(s) citing the data, what georegions are on the authors main addresses (i.e. when doing the work)? Please select all relevant options.**
> * **0.1 Does the paper use code?**
> * **0.2 If the paper uses code, and this is NOT archived (i.e. they mention using R or Python but don't provide any scripts) please copy-paste the text from the paper that alerted you to them using code...**
> * **0.3 Does the paper have archived code?**
> * **1. Is the code archiving described in the Data Availability (or equivalent) statement?**
> * ** *Please paste the section of the text that refers to the archived code if this is NOT part of the Data Availability Statement*.**
> * **2. Are you able to find the code using the link/instructions in the Data Availability (or equivalent) statement?**
> * **3. Where are the code archived?**
> * **4. Does the code have a DOI?**
> * **5. Can you download the code?**
> * **6. Can you open the code?**
> * **7. What language is the code written in?**
> * **8. What format is the code in?**
> * **9. Does the code have a README?**
> * **10. How useful is the README? See the protocol for help with making decisions about this. SKIP THIS Q IF NO README EXISTS.**
> * **11. How well is the code annotated? See the protocol for help with making decisions about this.**
> * **12. Does the code have a separate vignette with examples of how the code should be used?**
> * **13. If the code is an R Package, and it was previously available on CRAN/Bioconductor (as stated in the Data Availability statement), is it still available? Check this by trying to install it on the most recent version of R. If you don't know how to do this/can't do this choose \"Unable to check\"**
> * **14. If the code is a package in another language (e.g. Python) published on PyPI please put the name of the package here and where it has been deposited we will see if it is still available. If you know how to look this up yourself, please do and mention whether it is still available here (Yes/No)**
> * **15. Does the code have a CITATION file?**
> * **16. Does the code have a license?**
> * **17. If yes, what license?**
> * **18. APPLICATION papers only. How many times has the paper been cited? You can find this on the landing page of the paper.**
> * **19. Has the code been cited (excluding the original paper it was archived for)? Code = the archived code (not the paper or package).**
> * **20. If yes, how many times? (excluding the original paper it was archived for) Enter number or Unclear**
> * **21. Do you have any other comments about the code? For example for those familiar with these processes, does the code use unit test? Doe it have continuous integration? Does it use docker/other containers?**
> * **21. Has the code been cited by someone other than the original authors?**
> * **22. If yes, how many times? Enter number or Unclear**
> * **1. Did you have any issues recording data for this paper? If yes we will go back and check it for you later.**
> * **2. Any other comments about this paper?**
> * **2. What date did you do this? (YYYY-MM-DD)**
> * **...61**
> * **...62**
> * **...63**
> * **...64**
> * **...65**
> * **...66**
> * **recorder_ID**  

