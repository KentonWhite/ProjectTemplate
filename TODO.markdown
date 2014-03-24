# The ProjectTemplate TODO

## Unit Testing of File Formats
* Get a copy of the standard sample data file in `.rec` format.
* Get a copy of the standard sample data file in `.mtp` format.
* Get a copy of the standard sample data file in `.m` format.
* Get a copy of the standard sample data file in `.sys` format.
* Get a copy of the standard sample data file in `.syd` format.
* Get a copy of the standard sample data file in `.sas` format.
* Get a sample data file in `.mp3` format.

## Database Autoloading
* Find a way to unit test MySQL support.
* Clean up DB code in `sql.reader.R`.
* Improve ODBC support.
* Add JDBC support.
 
## Allow Users to Dump Static Project
* Add `create.project(dump = TRUE)` feature.

## Documentation
* Document `cache_loading` setting.
* Document possible data pipelines through `data` and `cache`.
* Produce a screencast featuring SQLite and SPSS autoloading and letters data.
* Document overriding a default reader.
* Create a tarball of the final state of the walkthrough project for the intro tutorial.

## Internal State
* `cache.project()` needs to deal with tools that generate data sets that don't meet naming conventions: e.g. `.db` files.
* Add unit test to check that `show.project()` doesn't produce an error.

## Excel Support
* Decide between gdata or xlsxjars for Excel support.

## Error Handling
* The whole codebase needs more error checking and needs to try to recover from more types of errors.

## New File Types
* Autoload audio, image and video file formats beyond `.ppm` and `.mp3`.

## More Ambitious Goals
* Make `data.table` integration more powerful.
* Integrate `sqldf`?
* Integrate `bigmemory` or `ff`?
* Automatic date conversion using lubridate.

## Cache Changes?
* Invalidate a file in `cache` if the matching file in `data` is more recently modified?

## Scaffolding
* Compact directories.
* .gitignore, .gitkeep

* CSV quote character control.
