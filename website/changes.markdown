---
layout: page
---
For latest release notes please visit the [Releases page](https://github.com/johnmyleswhite/ProjectTemplate/releases) at GitHub.
Bleeding-edge development is reflected in the [ChangeLog](https://github.com/johnmyleswhite/ProjectTemplate/blob/master/ChangeLog) and in the [list of commits](https://github.com/johnmyleswhite/ProjectTemplate/commits/master):
The raw ProjectTemplate source code is always the place to go for ground truth.

The list of changes below covers all releases up to and including v0.4-2. It is not necessarily exhaustive.

#### v0.4-2

* Had to disable xlsx.reader temporarily because it does not build for 2.15.

#### v0.4-1

* Added 'eda.R' example file in 'src/' directory.
* Allow loading from 'cache/' without loading from 'data/' through 'cache_loading' setting.
* Revised documentation.

#### v0.3-6

* Added Postgres support through RPostgreSQL
* Very rough ODBC support. See example in `ProjectTemplate:::sql.reader` documentation.
* `.dat` files are now read as if they were `.wsv` files.
* Revised documentation.

#### v0.3-5

* Added a `cache.project()` function.
* `as_factors` configuration option suppresses automatic character-to-factor conversion.
* Implemented `.zip` support using temporary files.
* Added `.mp3` support through the tuneR package.
* Added `.ppm` support through the pixmap package.
* `data_tables` configuration option automatically translates data sets into data.tables.
* Added unit tests for SPSS, Stata and SAS file formats.

#### v0.3-4

* Improved SQLite3 support:
  * Load all tables from SQLite3 database using a `.sql` file: set `table = "*"`
  * Load all tables from SQLite3 database automatically using `.db` extension.
* Added a .file type that can load files outside of the project directory.
* Renamed `run.tests()` to `test.project()`.
* Added a `stub.tests()` function that autogenerates tests for helper functions.
* Added a `show.project()` function that gives all known information about a project's internal state.

#### v0.3-3

* Added a `reload.project()` function.
* Improved error handling.
* Renamed `utilities.R` to `helpers.R`.
* Fixed a bug in `cache()`.

#### v0.3-2

* Added support for several new data formats.

#### v0.3-1

* Changed the configuration system from YAML to DCF format.
* Moved the data loading helper functions into separate files. They are no longer nested inside of `load.project()`.
* Started controlling which functions are exported using a NAMESPACE file.
* Added the ability to create minimal projects as well as the full projects that existing users will be familiar with.
* Switched all the `print()` calls to `message()` calls.
* Fixed a bug in cache().

#### v0.2-1

* Version 0.2-1 adds the following directories:
  * `cache`
  * `config`
  * `logs`
  * `munge`
  * `src`
* Inside the `config` directory, a global configuration file called `config/global.yaml` has been added that uses YAML syntax. This file provides the following configuration options:
  * `data_loading`: This can be set to 'on' or 'off'. If `data_loading` is on, the system will load data from both the `cache` and `data` directories with `cache` taking precedence in case of name conflict.
  * `munging`: This can be set to 'on' or 'off'. If `munging` is on, the system will execute the files in the `munge` directory sequentially. If `munging` is off, none of the files in the `munge` directory will be executed.
  * `logging`: This can be set to 'on' or 'off'. If `logging` is on, a logger object using the `log4r` package is automatically created when you run `load.project()`. This logger will write to the `logs` directory. By default, `logging` is off.
  * `load_libraries`: This can be set to 'on' or 'off'. If `load_libraries` is on, the system will load all of the R packages listed in the `libraries` field below.
  * `libraries`: This is a YAML array listing all of the packages that the user wants to automatically load when `load.project()` is called.
