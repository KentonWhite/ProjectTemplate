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
* Switch over to using roxygen and devtools.
* Document possible data pipelines through `data` and `cache`.
* Produce a screencast featuring SQLite and SPSS autoloading and letters data.
* Document overriding a default reader.

## Internal State
* `cache.project()` needs to deal with tools that generate data sets that don't meet naming conventions: e.g. `.db` files.
* Deal with `no global binding visible for project.info` error.
* Assign `project.info` into ProjectTemplate namespace?
* Add unit test to check that `show.project()` doesn't produce an error.

## Excel Support
* Decide between gdata or xlsxjars for Excel support.

## Error Handling
* The whole codebase needs more error checking and needs to try to recover from more types of errors.

## Characters As Factors
* Add a configuration variable to force all loading functions to read data sets in using `as.is = TRUE`. At present, generating factors can be a time sink, especially when the factors are converted back into characters during munging.

## New File Types
* Autoload audio, image and video file formats beyond `.ppm` and `.mp3`.
