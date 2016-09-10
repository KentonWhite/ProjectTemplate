This is a record of the changes made by CS

Branch ProjectTemplate 2
========================

* update cache only if there's not already a cache object (but do default behaviour of caching always). This allows munge scripts to skip caching if it takes a long time which allows load.project to run quicker.

* have a file called custom.dcf in the config directory which adds config variables which are relevant for that project only. These can be anything (char, numeric, logical) etc and allows for analysis configuration (e.g. I use it to determine which variables should be cached in the analysis)

* new function clear.cache which allows specific cache objects to be deleted (forcing data to be re-read from raw data). I also use this to only run long analysis in munge if the data isn't already cached which saves time again when load.project is run.

This branch was submitted to the master Project as a pull request:

https://github.com/johnmyleswhite/ProjectTemplate/pull/152

Branch ProjectTemplate 2
========================

* Add in a function to copy in a template structure from a file location during create.project()

