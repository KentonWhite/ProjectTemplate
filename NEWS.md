0.9.3 (2020-12-03)

Internal
--------
* Fix passing first argument with length greater than 1 to `exists()` (Breaking change in R 4.1.0)
* Fix issue where some Namespaces where not properly resolved in `cache()` (#303).

0.9.2 (2020-05-11)

Features
--------
* Supports underscores in variable names, replacing the old dot ('.') separator.

0.9.1 (2020-04-15)

Internal
-------
* `as_factor` defaults to `FALSE`.  This is for compatibility with R 4.0, which is deprecating `stringsAsFactors()`

0.9.0 (2019-02-26)

Features
--------
* New for R 3.6, support for staged install (#291)
* Define default table types using config var `tables_type` (#274)
* Support for `feather` files (#239)
* Migration from `csv2.reader` to `read.csv2` (#195)
* Supports `rstudio.project` files (#201)

Documentation
-------------
* Link website documentation current release to News.md
* Added file types to `dat` directory `README` (#268)
* Internal functions are now documented (#243)

Internal
--------
* `data_ignore` applies to `cache` vars (#290)
* More informative error messages if not in a ProjectTemplate Directory (#287)
* `migrate_project()` creates missing `cache` directory (#275) 

0.8.2 (2018-04-20)

Features
--------

* Uses the Tidyverse packages (#207)
* Added custom templates (#206)
* Added support for rds files (#224, #227)


Documentation
-------------

* Documentation moved to `docs` folder.  Will automatically update on website

Internal
--------

* Added tibble support (#218)
* Moved from `xls` package to `readxl` package (#159, #219)
* Allow overridng of globals (#222)
* Fixed failing test for `RSQLlite` package (#228)


0.8.1 (2017-08-28)

Features
--------

* Faster caching (#152, #155, #160, #166)
* New clear() function to manage global environment (#167, #172, #173, #183)
* New project.config() function and configuration help page (#164)
* Renamed doc to docs and added references to GitHub Pages configuration (#180)
* Added config option to treat the first row of a data file as header (current default) or not. (#168)
* Change csv2.reader() behavior to act as expected when running  read.csv2() (#195)
* Add list.data and incorporate in load.project (#187)

Documentation
------------

Internal
--------
* Moved logger initialization to before loading helper functions, See issue #150
* Cleaner exit when running load.project() in the wrong directory (#157)
* Allow to call RSQLite's initExtension() (#161)
* Refactor migrate.project() and fix version tests (#162)
* Clean exit for more functions when current directory is not valid Project template (#163)
* Enable dcf files to contain R code that can be evaluated upon read (#169)
* Changed execution environment of CODE chunks (#171)
* Remove unused function .get.template.tar.path in create.project and old commented out code in load.project (#181)
* Uniform reading/writing global.dcf (#184)
* Ignore files in data directory (#178)
* Remove warnings from Travis and devtools::test() checks (#188)
* De-deprecated devtools installation command (#193)
* Bug Fix:  Missing hash file causes failure in subsequent cache() operation (#194)

0.7 (2016-07-29)
 
Features
--------

* `create.project()` creates `README.md` files in each subdirectory (#128). The README file in the main directory is now also formatted as Markdown, with the project name as title.
* Code that creates and runs tests now also allows non-R files in `libs` and `tests` subdirectories.
* Libraries from the `libraries` section are loaded before sourcing `lib/` files (#130).
* Missing packages are installed automatically (#146, @wilmeragsgh).
* Added `dplyr` to the list of default libraries in `global.dcf` (#143, @pavopax).
* `cache()` gains a new `...` argument which is passed to `save()` (#148, @eribul).
* Use `inherits = FALSE` in `get()` calls within specific environments (#139, @famuvie)
* The `port` option is now used for `RPostgreSQL` connections.

Documentation
-------------

* Update to getting-started/mastering documentation (#142, @matt-jay).
* Fix typo in error msg (#141, @famuvie).

Internal
--------

* Isolate tests by using temporary directories and properly undoing `setwd()` calls (#132).
* `R CMD check` shows no errors, warnings, or notes.


v0.6 (2014-10-05)
===

* Includes all modifications from v0.5-3 and v0.5-2.

v0.5-3 (2014-10-05)
===

* Packages required for loading data sources are attached to the search path (with a warning) only if the new compatibility setting `attach_internal_libraries` is set to `TRUE`.  Attaching packages to the search path seems to be unnecessary to achieve proper functionality, but users might rely on this behavior, and so this is the default for migrated projects but turned off for new projects (#104).

v0.5-2 (2014-10-01)
===

Bug fixes
---

* Fixed error message when `require.package` is called from an anonymous
  function and fails to load a package.  (Using `deparse(nlines = 1)` now.)


Features
---

* Added function `.add.extension()`. This allows users to create custom readers for extensions, either locally in a project or as packages.
* The configuration now stores the version of ProjectTemplate in the `version`
  field (#90).
* New function `migrate.project()` that allows upgrading a project to the
  current version of ProjectTemplate (#90, #121).
* New parameter `override.config` to `load.project()` and `reload.project()`
  allows substitution of individual configuration items (#76).
* Can use mustache style templating in SQL calls to access project data structures (#50).
* Support passwordless connection to postgresql databases (#115).
* Configuration entries that start with a hash (`#`) are silently ignored (#74).
* New variables `default.config` and `new.config` that store the default
  configuration used for missing configuration items or for a new project (#76, #89).
* Missing but required directories are now created (with a warning) (#76).
* Missing entries in the configuration file, or a missing configuration file,
  are substituted by defaults (with a warning).  Extra entries are ignored
  (with a warning) (#76).
* All logical configuration options are now stored as Boolean values instead of
  `'on'`/`'off'`.  Input values other than `'on'`/`'off'` are converted using
  `as.logical`, invalid values result in an error (#76).


Internal
---

* Dropped dependency on `Defaults` package (#100).
* Suppress warnings in tests (#111).
* Fix CRAN check issues (#117).
* Improved presentation of available readers in documentation (#119).


v0.5-1 (2014-03-17)
===

Bug fixes
---

* Restore compatibility to R 2.15.3 by avoiding use of the `no..` parameter
  to `list.files()` in our `create.project()` function.

v0.5 (2014-03-13)
===

Features
---

* New function `get.project()` to access `project.info`.
* Attempting to load a missing package when reading data will lead to a
 user-friendly error message (#26).
* Export existing `translate.dcf` function, useful for implementing custom readers (#59).
* Add new function `.add.extension.` This allows users to create custom readers
  for extensions, either locally in a project or as packages (#59).

Internal
---

* Fix CRAN warnings concerning use of `ProjectTemplate:::` qualification
  (#56).
* Fix CRAN warnings concerning assignments to `.GlobalEnv`.
* Updated author information in DESCRIPTION file (#40).
* Store templates for empty projects in tar files instead of storing
  the entire directory structure per CRAN request and to avoid having to build
  with the `--keep-empty-dirs` switch (#41).

v0.4-5 (2014-02-11)
===

* New maintainers: Kirill Müller  <mail@kirill-mueller.de>, Kenton White  <jkentonwhite@gmail.com>
* Allow string interpolation of R functions in sql queries
* Added a JDBC database wrapper for accessing PostgreSQL databases hosted by Heroku (#20)
* JDBC connection can now use path to jar stored in CLASSPATH
* project.info is stored in the global environment again (reverted change from
  0.4-4); the active binding seemed to work for the tests but not from outside
  the package
* create.project now works if the directory exists. Merging with a non-empty
  directory is supported by setting the new parameter merge.strategy.

v0.4-4 (2013-08-11)
===

* Fix CRAN checks (@krlmlr).
* project.info is now an active binding to avoid writing to the global
  environment (@krlmlr).
* Re-enabled xlsx.reader (@krlmlr).
* Added JDBC support to sql.reader (@joshbode, #12).
* Various MySQL improvements (@cortex, #10).
* Fix "Argument port must be an integer value" when using port number for mysql
  driver (@cortex, #7).
* Tentative CSV2 support.

v0.4-3 (2012-08-11)
===

* Added optional recursive data directory loading using a 'recursive_loading' setting.
* Added basic Oracle support (with tnsnames, no host/port) (@matteoredaelli, #6).

v0.4-2 (2012-05-12)
===

* Had to disable xlsx.reader temporarily because it does not build for 2.15.

v0.4-1 (2011-11-23)
===

* Added 'eda.R' example file in 'src/' directory.
* Allow loading from 'cache/' without loading from 'data/' through 'cache_loading' setting.
* Revised documentation.

v0.3-6 (2011-07-13)
===

* Added Postgres support through RPostgreSQL
* Very rough ODBC support. See example in ProjectTemplate:::sql.reader documentation.
* '.dat' files are now read as if they were '.wsv' files.
* Revised documentation.

v0.3-5 (2011-07-08)
===

* Added a cache.project() function.
* 'as_factors' configuration option suppresses automatic character-to-factor conversion.
* Implemented .zip support using temporary files.
* Added .mp3 support through the tuneR package.
* Added .ppm support through the pixmap package.
* 'data_tables' configuration option automatically translates data sets into data.tables.
* Added unit tests for SPSS, Stata and SAS file formats.

v0.3-4 (2011-07-03)
===

* Increased SQLite3 support
* Load all tables from SQLite3 database using a .sql file: set table = *
* Load all tables from SQLite3 database automatically using .db extension
* Added a .file type that can load files outside of the project directory.
* Removed run.tests(). Use test.project().
* Added a stub.tests() function that autogenerates tests for helper functions.
* Added a show.project() function that gives all known information about a project's internal state.

v0.3-3 (2011-06-28)
===

* Added a reload.project() function.
* Improved error handling.
* Renamed utilities.R to helpers.R.
* Fixed a bug in cache().

v0.3-2 (2011-06-27)
===

* Added new *Reader functions.

v0.3-1 (2011-06-24)
===

* Switched configuration system over to DCF format.
* Ability to create full projects or minimal projects.
* Switched print() calls to message() calls.
* Moved *Reader functionality into separate functions that users can override.
* Fixed a bug in cache().

v0.2-1 (2010-12-03)
===

* Moved boot.R's logic into functions and configuration files.
* Added SQLite support using the RSQLite package.
* Cleaned up the database connection and disconnection code.
* Changed list of packages listed as dependencies, so that even more are suggestions.
* Added new configuration settings in config/global.yaml.
* Data is now loaded from a cache/ directory and then the traditional data/ directory.
* Added log4r integration, which is configurable and turned off by default.
* Added a sample preprocessing script.
* Added a cache/ directory.
* Added a config/ directory.
* Added a logs/ directory.
* Added a munge/ directory.
* Added a src/ directory.
* Fixed a bug in clean.variable.name() for variable names that start with numbers.
* Added XSLX support.

v0.1-3 (2010-10-02)
===

* Many changes to load_data.R.
* Added notices when data sets are autoloaded.
* Added autoload support for WSV (whitespace separated values) data files.
* Added autoload support for RData files.
* Added autoload support for compressed *SV files.
* Added autoload support for *SV files available through HTTP.
* Added autoload support for MySQl database tables.
* Added autoload support for SPSS and Stata files.
* Added test.project as an alias for run.tests().
* Changed list of packages listed as dependencies, so that many are now suggestions.
* load.project() does not autoload libraries that are not dependencies.
* Added a sample profiling script.
* Added a sample test that always passes to the default project.
* Added a basic show.updates() function for porting projects to newer releases of ProjectTemplate.

v0.1-2 (2010-08-26)
===

* Cleaned up documentation.
* Rewrote backend.
* Added load.package() and run.tests() functions.

v0.1-1 (2010-08-24)
===

* Maintainer: John Myles White  <jmw@johnmyleswhite.com>
* Initial release.
