# ProjectTemplate

The ProjectTemplate package provides a single function `create.project()` that automatically builds a directory for a new R project with a clean directory structure and useful utility programs for automating the loading of project data. The hope is that standardized and automated data loading, automatic loading of best practice packages and useful nudges towards keeping cleanly organized code will improve the quality of R coding.

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

To do work on such a project, enter the main directory, open R and type `source('lib/boot.R')`. This will run `lib/load_libraries.R`, which automatically loads the `plyr`, `reshape`, `stringr` and `ggplot2` packages. `lib/load_data.R` will then be called, which will automatically import any CSV or TSV data files inside of the `data/` directory. If you have a large number of normalized data sets for your package, this can save you a lot of manual importing steps. After this, `lib/preprocess_data.R` will be called, which allows you to make any run-time modifications to your data sets automatically.
