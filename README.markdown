# Introduction
The ProjectTemplate package provides a single function `create.project()` that automatically builds a directory for a new R project with a clean sub-directory structure and automatic data and library loading tools. The hope is that standardized and automated data loading, automatic loading of best practice packages and useful nudges towards keeping a cleanly organized codebase will improve the quality of R coding.

# Overview
As far as ProjectTemplate is concerned, a good project should look like the following:

* project/
    * data/
    * diagnostics/
    * doc/
    * graphs/
    * lib/
        * boot.R
        * load_data.R
        * load_libraries.R
        * utilities.R
    * profiling/
    * reports/
    * tests/
    * README
    * TODO

To do work on such a project, enter the main directory, open R and type `source('lib/boot.R')`. This will then automatically perform the following actions:

* `source('lib/load_libraries.R')`, which automatically loads the CRAN packages currently deemed best practices. At present, this list includes:
    * `reshape`
    * `plyr`
    * `stringr`
    * `ggplot2`
    * `testthat`
* `source('lib/load_data.R')`, which automatically import any CSV or TSV data files inside of the `data/` directory.
* `source('lib/preprocess_data.R')`, which allows you to make any run-time modifications to your data sets automatically. This is blank by default.
