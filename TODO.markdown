# The ProjectTemplate TODO

## Unit Testing of File Formats
* Get a copy of the standard sample data file in `.sav` format.
* Get a copy of the standard sample data file in `.dta` format.
* Get a copy of the standard sample data file in `.dbf` format.
* Get a copy of the standard sample data file in `.rec` format.
* Get a copy of the standard sample data file in `.mtp` format.
* Get a copy of the standard sample data file in `.m` format.
* Get a copy of the standard sample data file in `.sys` format.
* Get a copy of the standard sample data file in `.syd` format.
* Get a copy of the standard sample data file in `.xport` format.
* Get a copy of the standard sample data file in `.sas` format.

## Database Autoloading
* Find a way to unit test MySQL support.
* Clean up DB code.

## Allow Users to Dump Static Project
* Add `create.project(dump = TRUE)` feature.

## Documentation
* Document possible data pipelines through `data` and `cache`.

## Internal State
* Create a `cache.project()` function using this record.
* Need to deal with tools that generate data sets that don't meet naming conventions: e.g. `.db` files.
* Deal with `no global binding visible for project.info` error.

## Excel Support
* Decide between gdata or xlsxjars for Excel support.

## Zip Support
* Fix `.zip` support.
* Create temporary file, unzip there, then read in and delete the temporary file.

## Error Handling
* The whole codebase needs more error checking and needs to try to recover from more types of errors.
