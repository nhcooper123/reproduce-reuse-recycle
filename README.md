# reproduce-reuse-recycle

Code and data for MEE paper

Author(s): Natalie Cooper and the hack-a-thon gang

*This README is a work in progess*

This repository contains all the code and some data used in the [paper](XXX). 

To cite the paper: 
>  Natalie Cooper and the BES Data and Code Hackathon Group. YEAR. Data- and code-archiving in the British Ecological Society journals: present status and recommendations for future improvements.

To cite this repo: 
>  Natalie Cooper. Code for MEE paper v1.

This code is shared under an MIT License.

![alt text](https://github.com/nhcooper123/reproduce-reuse-recycle/raw/main/figures/summary-journal-year.jpg)

-------
## Data

### Raw data

Note that non-anonymised data are not available here for privacy/GDPR reasons. 

* BES_2015-2024_article_data_2025-09-02.csv
* **BES-data-code-hackathon-raw-outputs_ANON_2025-11-16.csv**
* **fixing-papers-with-issues.csv**

### Data

"data/2025-09-29_BES-article-metadata-2015-2024.csv"
BES-data-code-hackathon-cleaned_2025-12-01.csv
data-validation_2025-11-16.csv

-------
## Analyses

1. The first step of the analyses was to take the list of published papers across the BES journals from 2017-2024 and wrangle this data to create a list of papers participants could collect data from. This script cleans the data, removes paper types that are unlikely to share data/code e.g. reviews, randomises the order of papers and assigns each a unique ID called `paper_number` which is used to refer to papers in the rest of the analyses.

Code for these analyses are in the subfolder `prepare-paper-list`.

* **00-wrangle-raw-data.R**. This code uses the  `BES_2015-2024_article_data_2025-09-02.csv` dataset in the `raw-data/` folder. It outputs `data/2025-09-29_BES-article-metadata-2015-2024.csv`. Note that the names of these files suggest data from 2015 onwards was available but in reality only data from 2017 onwards was provided by Wiley.

We used this list during the hackathon.

2. Next the collected data from the hackathon had to be anonymised due to GDPR legislation. Each unique data recorder (or group of data recorders where people were working as a team) was given a unique recorder ID number, then their names and details were removed from the data.

* **01_anonymise-recorders.r**. This code uses `non-anonymised-data/BES-data-code-hackathon-raw-outputs.csv` which cannot be shared due to GDPR legislation. It outputs the shareable `raw-data/BES-data-code-hackathon-raw-outputs_ANON.csv`

3. This script takes the raw data (`BES-data-code-hackathon-raw-outputs_ANON_2025-11-16.csv`) and (slowly and painfully) cleans it so it can be used in the analyses. The script removes excess variables we did not use in the final analyses, standardises write up answers, fixes typos, removes duplicate entries etc. It also selects all entries for paper 2272 which we used to look at data recorder variability.

* **02_initial-data-cleaning.r**. This code uses "raw-data/BES-data-code-hackathon-raw-outputs_ANON_2025-11-16.csv" and outputs "data/BES-data-code-hackathon-cleaned_2025-12-01.csv" and "data/data-validation_2025-11-16.csv"


* **03_summary-stats-plots.qmd**
* **04_figures-for-paper.r**
* **05_tables-for-paper.r**
* **06_by-journal-figures-for-supplemental.r**
* **07_through-time-figures-for-supplemental.r**
* **08_readmes-by-archive.r**
* **09_recorder-variability.r**
* **prepare-paper-list**

-------
## Other folders

* `/figures` contains all figures for the paper and supplementary information.
* `/tables` contains all tables


-------
## Session Info
For reproducibility purposes, here is the output of `devtools::session_info()` used to perform the analyses in the publication.
 
## Checkpoint for reproducibility
To rerun all the code with packages as they existed on CRAN at time of our analyses we recommend using the `checkpoint` package, and running this code prior to the analysis:

```{r}
checkpoint("2025-12-01")
```
