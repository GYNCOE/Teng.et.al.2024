## Teng.et.al.2024

# ProteoMixture

[ProteoMixture Portal Link](https://lmdomics.org/ProteoMixture/)

### A software tool supporting prediction of tumor, stroma and immune cell admixture in bulk ovarian cancer tissue collections using protein-level abundance data.

This repository serves as a place to store relevant code and resources utilized for the writing of the [Teng et al 2024 manuscript published in iScience](https://www.cell.com/iscience/fulltext/S2589-0042(24)00419-X), but mostly the recursive feature selection section. The [SVR_RFE.ipynb](SVR_RFE.ipynb) file can be run using the data provided in this repository. This file takes lists of protein candidates for 3 cell types (tumor, lymphocyte, stroma) ([data/admixture/protein candidates.xlsx](data/admixture/protein%20candidates.xlsx)) and uses recursive feature elimination (RFE) to reduce the number of proteins in each list while keeping as much predictive power as possible.

*NOTE:* `limma` analysis on pure tissue sample proteomics with logFC and p value cutoffs yielded the [initial protein candidates](data/admixture/protein%20candidates.xlsx), (adjusted and unadjusted p value < 0.05 for tumor and lymphocytes, unadjusted p value < 0.05 for stroma, fold change (FC) cutoff = 1.5 or LogFC cutoff = 0.585).

## Contents
* [data/](#data)
* [figures/](#figures)
* [GSEA.r](#gsear)
* [rfe_environment.yml](#environment)
* [SVR_RFE.html](#svr_rfe_html)
* [SVR_RFE.ipynb](#svr_rfe_ipynb)

# SVR_RFE.ipynb <a id='svr_rfe_ipynb'></a>
[SVR_RFE.ipynb](SVR_RFE.ipynb) is meant to encompass the entire support vector regression (SVR) recursive feature elimination (RFE) pipeline, from initially reduced features to the final selected features. 

## Notebook overview:
### Sections can be viewed in [SVR_RFE.ipynb](SVR_RFE.ipynb)

1. Import required packages and display version information
2. Initial feature reduction
    1. Load data
        * Initial feature lists
        * CPTAC 
        * HGSOC 
        * Celladmixture tissue data
    2. Split tissue data into test/train
    3. Hyperparameter tuning
    4. Perform RFE on reduced CPTAC + HGSOC + Protein Candidate features
        * SVM SVR
        * Save model performances
    5. Choose reduced featuresets
        * at least 15 features, lowest test MSE
3. Validation
    1. CPTAC
        * model results
        * ssGSEA
    2. N9 HGSOC
        * model results
        * ssGSEA

# data/ <a id='data'></a>
[data/](data/) holds all of the data that is required to run the [SVR_RFE.ipynb](SVR_RFE.ipynb) file.

# figures/ <a id='figures'></a>
[figures/](figures/) holds all the figures that are created by [SVR_RFE.ipynb](SVR_RFE.ipynb). 
Mainly, this includes:
* support vector regression (SVR) model results for each tissue type
* CPTAC validation results
* HGSOC validation results

# GSEA.r <a id='gsear'></a>
[GSEA.r](GSEA.r) is an R script that utilizes `GSEABase` and `GSVR` to run ssGSEA.

# rfe_environment.yml <a id='environment'></a>
[rfe_environment.yml](rfe_environment.yml) is a YAML conda environment to easily reproduce the Python environment used to run [SVR_RFE.ipynb](SVR_RFE.ipynb). Learn how to create a conda environment from a .yml file [here](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-from-an-environment-yml-file)!

# SVR_RFE.html <a id='svr_rfe_html'></a>
[SVR_RFE.html](SVR_RFE.html) is an HTML version of [SVR_RFE.ipynb](SVR_RFE.ipynb), created using [`nbconvert`](https://pypi.org/project/nbconvert/).
