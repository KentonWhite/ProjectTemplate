* New parameter `override.config` to `load.project()` and `reload.project()`
  allows substitution of individual configuration items.
* Missing but required directories are now created (with a warning).
* All logical configuration options are now stored as Boolean values instead of
  `'on'`/`'off'`.  Input values other than `'on'`/`'off'` are converted using
  `as.logical`, invalid values result in an error.
* Missing entries in the configuration file, or a missing configuration file,
  are substituted by defaults (with a warning).  Extra entries are ignored
  (with a warning).
* New variable `default.config` that stores the default configuration used
  for a new project.

* Fixed error message when `require.package` is called from an anonymous
  function and fails to load a package.  (Using `deparse(nlines = 1)` now.)

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
* Reenabled xlsx.reader (@krlmlr).
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
