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


?????Table S1 numbers

Analyses were carried out in the following order.

* **00-wrangle-raw-data.R**. 

This preliminary data wrangling script is in the subfolder `prepare-paper-list`.

The first step of the analyses was to take the list of published papers across the BES journals from 2017-2024 and wrangle this data to create a list of papers participants could collect data from. This script cleans the data, removes paper types that are unlikely to share data/code e.g. reviews, randomises the order of papers and assigns each a unique ID called `paper_number` which is used to refer to papers in the rest of the analyses.

This script uses the  `raw-data/BES_2015-2024_article_data_2025-09-02.csv` dataset. It outputs `data/2025-09-29_BES-article-metadata-2015-2024.csv`. Note that the names of these files suggest data from 2015 onwards was available but in reality only data from 2017 onwards was provided by Wiley.

We used this list during the hackathon.

* **01_anonymise-recorders.r**. 

Next the collected data from the hackathon had to be anonymised due to GDPR legislation. Each unique data recorder (or group of data recorders where people were working as a team) was given a unique recorder ID number, then their names and details were removed from the data.

This script uses `raw-data/non-anonymised-data/BES-data-code-hackathon-raw-outputs.csv` which cannot be shared due to GDPR legislation. It outputs the shareable `raw-data/BES-data-code-hackathon-raw-outputs_ANON.csv`

* **02_initial-data-cleaning.r**.

This script takes the raw data (`BES-data-code-hackathon-raw-outputs_ANON_2025-11-16.csv`) and (slowly and painfully) cleans it so it can be used in the analyses. The script removes excess variables we did not use in the final analyses, standardises write up answers, fixes typos, removes duplicate entries etc. It also selects all entries for paper 2272 which we used to look at data recorder variability.

 This script uses `raw-data/BES-data-code-hackathon-raw-outputs_ANON_2025-11-16.csv` and outputs `data/BES-data-code-hackathon-cleaned_2025-12-01.csv` and `data/data-validation_2025-11-16.csv` the processed datasets used in all subsequent analyses.

* **03_summary-stats-plots.qmd**

This script explores the data in `data/BES-data-code-hackathon-cleaned_2025-12-01.csv`, and produces several summary figures and tables. These are for information purposes and not output for use in the paper. 

* **04_figures-for-paper.r**

This script uses `data/BES-data-code-hackathon-cleaned_2025-12-01.csv` to create all the figures used in the paper and some in the supporting information. This script outputs Figures 1-7 and Supporting Figure S16. All figures are output to the `/figures` folder.

* **05_tables-for-paper.r**

This script uses `data/BES-data-code-hackathon-cleaned_2025-12-01.csv` to extract numbers used in tables in the paper and the supporting information. It also contributes numbers cited in the paper text. This script outputs numbers used in Tables S2-S4, though several tables are combined to create each of these tables. All tables are output to the `/tables` folder.

* **06_by-journal-figures-for-supplemental.r**

This script uses `data/BES-data-code-hackathon-cleaned_2025-12-01.csv` to create all the journal-specific figures used in the supporting information. This script outputs Supporting Figures S1-S14. All figures are output to the `/figures` folder.

* **07_through-time-figures-for-supplemental.r**

This script uses `data/BES-data-code-hackathon-cleaned_2025-12-01.csv` to create figures of the different variables but separated by year published. This no longer forms part of the paper but is included for completeness. All figures are output to the `/figures` folder.

* **08_readmes-by-archive.r**

This script uses `data/BES-data-code-hackathon-cleaned_2025-12-01.csv` to determine whether README quality varies by archive. This no longer forms part of the paper but is included for completeness. All figures are output to the `/figures` folder.

* **09_recorder-variability.r**

This script uses `data/BES-data-code-hackathon-cleaned_2025-12-01.csv` to investigate variability in data recorders by investigating how 100 different unique data recorders collected data for paper 2272. This script outputs Supporting Figure S15, and the numbers in used in the Supporting Information and main text when describing data recorder variability. The figure is output to the `/figures` folder.

-------
## Other folders

* `/figures` contains all figures for the paper and supporting information.
* `/tables` contains all tables for the paper and supporting information. 

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
