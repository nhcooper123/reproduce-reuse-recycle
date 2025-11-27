# reproduce-reuse-recycle

Code and data for pinniped macroevolution paper

Author(s): Natalie Cooper and the hack-a-thon gang

*This README is a work in progess*

This repository contains all the code and some data used in the [paper](XXX). 

To cite the paper: 
>  XXX

To cite this repo: 
>  XXX

![alt text](https://github.com/nhcooper123/reproduce-reuse-recycle/raw/main/figures/summary-journal-year.jpg)

-------
## Data

### Raw data

Note that non-anonymised data are not available here for privacy/GDPR reasons. 

### Data


-------
## Other folders

* `/supplemental` contains the ESM files/figures and tables in LaTeX format.

-------
## Session Info
For reproducibility purposes, here is the output of `devtools::session_info()` used to perform the analyses in the publication.
 
## Checkpoint for reproducibility
To rerun all the code with packages as they existed on CRAN at time of our analyses we recommend using the `checkpoint` package, and running this code prior to the analysis:

```{r}
checkpoint("2025-12-01")
```
