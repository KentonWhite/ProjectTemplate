# Introduction
The ProjectTemplate package provides a function, `create.project()`, that automatically builds a directory for a new R project with a clean sub-directory structure and automatic data and library loading tools. The hope is that standardized data loading, automatic importing of best practice packages, integrated unit testing and useful nudges towards keeping a cleanly organized codebase will improve the quality of R coding.

The inspiration comes from the `rails` command from Ruby on Rails, which initializes a new Rails project with the proper skeletal structure automatically. Also, ProjectTemplate follows Rails's approach of preferring convention over configuration: the automatic data and library loading as well as the automatic testing work easily because assumptions are made about the directory structure and naming conventions used in your code. You can customize your codebase however you'd like, but you will have to edit the automation scripts to use your conventions instead of the defaults before you'll get their benefits again.

# Installing
This project is now on CRAN and can be installed using a simple call to `install.packages()`:

    install.packages('ProjectTemplate')

If you would like access to changes to this package that are not available in the current version on CRAN, please download the contents of this repository and then run,

    R CMD INSTALL ProjectTemplate_*.tar.gz

For most users, running the bleeding edge version of this package is probably a mistake. It is generally much less stable than the versions that have been released on CRAN.

# Example Code
To create a project called `my-project`, open R and type:

    library('ProjectTemplate')
    create.project('my-project')
    setwd('my-project')
    load.project()
    run.tests()

`load.project()` is essentially a mnemonic for calling `source('lib/boot.R')`. Similarly, `run.tests()` is essentially a mnemonic for calling `source('lib/run_test.R')`.

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
        * preprocess_data.R
        * run_tests.R
        * utilities.R
    * logs/
    * profiling/
        * 1.R
    * reports/
    * tests/
        * 1.R
    * README
    * TODO

To do work on such a project, enter the main directory, open R and type `source('lib/boot.R')`. This will then automatically perform the following actions:

* `source('lib/load_libraries.R')`, which automatically load the packages required for ProjectTemplate to function. This includes:
    * `testthat`
    * `yaml`
    * `foreign`
* You can edit `lib/load_libraries.R` to automatically load the suggested packages as well, which are:
    * `reshape`
    * `plyr`
    * `stringr`
    * `ggplot2`
    * `log4r`
* `source('lib/load_data.R')`, which automatically imports any CSV or TSV data files inside of the `data/` directory.
* `source('lib/preprocess_data.R')`, which allows you to make any run-time modifications to your data sets automatically. This is blank by default.

# Default Project Layout
Within your project directory, ProjectTemplate creates the following directories and files whose purpose is explained below:

* `data/`: Store your raw data files here. If they are a supported file format, they will automatically be loaded when you call `load.project()` or `source('lib/boot.R')`, for which `load.project()` is essentially a mnemonic.
* `diagnostics/`: Store any scripts you use to diagnose your data sets for corruption or problematic data points. You should also put code that globally censors any data points here.
* `doc/`: Store documentation for your analysis here.
* `graphs/`: Store any graphs that you produce here.
* `lib/`: Store any files that provide useful functionality for your work, but do not constitute a statistical analysis per se here.
* `lib/boot.R`: This script handles automatically loading the other files in `lib/` automatically. Calling `load.project()` automatically loads this file.
* `lib/load_data.R`: This script handles the automatic loading of any supported files contained in `data/`.
* `lib/load_libraries.R`: This script handles the automatic loading of the required packages, which are `testthat`, `yaml` and `foreign`. In addition, you can uncomment the lines that would automatically load the suggested packages, which are `reshape`, `plyr`, `stringr`, `ggplot2` and `log4r`.
* `lib/preprocess_data.R`: This script handles the preprocessing of your data, if you need to add columns at run-time, merge normalized data sets or perform similar operations.
* `lib/run_tests.R`: This script automatically runs any test files contained in the `tests/` directory using the `testthat` package. Calling `run.tests()` automatically runs this script.
* `lib/utilities.R`: This script should contain quick general purpose code that belongs in a package, but hasn't been packaged up yet.
* `profiling/`: Store any scripts you use to benchmark and time your code here.
* `reports/`: Store any output reports, such as HTML or LaTeX versions of tables here. Sweave or brew documents should also go here.
* `tests/`: Store any test cases in this directory. Your test files should use `testthat` style tests.
* `README`: Write notes to help orient newcomers to your project.
* `TODO`: Write a list of future improvements and bug fixes you have planned.

# Automatic Data Loading
One of the major goals for ProjectTemplate is providing fully automatic data loading for R. For example, if your `data/` directory contains a data file called `data/choices.csv`, then ProjectTemplate will automatically load this file and create a global variable called `choices`. Using the `clean.variable.name()` function found in `lib/utilities.R`, filenames that contain underscores, dashes and whitespace are changed to use periods instead. For instance, `data/image_properties.tsv` creates a global variable called `image.properties`.

A large and growing number of file formats are supported by the automatic data loading script, including CSV files and related formats, RData files, remote data sets available over HTTP, Stata and SPSS formats and MySQL tables. For further details, read the `file_formats.markdown` file.

As of v0.1-3, `load.project()` prints out the name of every data set as it is loaded.

# Contributors and Thanks
Diego Valle-Jones contributed a patch that enabled the autoloading of compressed CSV data files. Inspiration for further extensions to the autoloading system came from reading the documentation for David Edgar Liebke's `get-dataset` function, which is part of the Clojure statistical library Incanter.

Many thanks to anyone who's made suggestions or comments about ProjectTemplate.

# Finding Out More
* Mailing List: ProjectTemplate has a Google Group, which can be found at http://groups.google.com/group/projecttemplate
* Website: Updates to ProjectTemplate are announced on http://www.johnmyleswhite.com
* Twitter: Updates to ProjectTemplate are announced on Twitter using the hashtag #ProjectTemplate.
