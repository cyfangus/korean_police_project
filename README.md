# Korean Police Project

## Overview
This repository contains the code and documentation for the analysis of the first_wave.csv dataset, aimed at investigating how the evaluattion of procedural justice in telephone non-face-to-face policing enviroment impact their willingess to report crime in future and satisfaction over the process.

The project follows reproducible research principles using R, RStudio, Git, and the renv package for dependency management.

## Getting Started
To run this analysis locally, follow these steps:

### Prerequisites
R (version 4.1.0 or later recommended)
RStudio IDE
Git command line tools installed and configured

### Installation and Setup
1. Clone the Repositor
```bash
git clone https://github.com
cd korean_police_project
```

2. Restore R Environment:
- Open the .Rproj file in RStudio.
- RStudio will prompt you to install the project-specific packages. Click "Yes".
- Alternatively, run renv::restore() in the R console to install the exact package versions used in this project.

### Project Structure
We follow a standard structure to separate raw data, cleaned data, and analysis scripts:

| Folder	| Contents |
|----|----|
| code/	| R scripts for data cleaning (01_cleaning.R), analysis, and visualization.|
| data/processed/	| Cleaned and processed datasets (derived data).|
| data_files/	| Raw, sensitive data files. These are stored locally and not committed to GitHub.|
| output/	| Generated plots, tables, and final reports.|

## Usage and Workflow
Scripts in the code/ directory should generally be run in order:
1. code/01_cleaning.R: Reads the raw data, uses janitor to clean names, filters data, and saves output to data/processed/..
2. code/02_analysis.R

## Important Note on Data Privacy
The raw data (first_wave.csv) used in this project is sensitive and *not committed* to this GitHub repository. A placeholder or example file might be provided, but the actual data must be sourced separately.
Secrets: We use environment variables via .Renviron for sensitive information (e.g., encryption keys or API keys). The .Renviron file is also excluded by .gitignore.

## Dependencies
This project uses renv to manage dependencies. The exact list of required packages and their versions can be found in the renv.lock file.

## License
MIT License 

## Contact
Angus Chan - cyfangus@gmail.com
