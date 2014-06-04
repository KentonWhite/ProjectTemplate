---
layout: page
---
Because ProjectTemplate is still beta software, there are a number of backwards incompatible changes introduced with each iteration of the package. The information below should help you upgrade an existing project to work with the newest version of ProjectTemplate.

##### Updating a v0.3-5 (or later) Project

* Simply call the new function `ProjectTemplate::migrate.project()`.  The functions `load.project()` and `reload.project()` will issue a warning if this is required.

##### Updating a v0.3-4 Project to a v0.3-5 Project

* Add lubridate to the `libraries` configuration settings in `config/global.dcf`.
* Add the `as_factors` configuration setting in `config/global.dcf`. Set it to "on".
* Add the `data_tables` configuration setting in `config/global.dcf`. Set it to "off".

##### Updating a v0.3-3 Project to a v0.3-4 Project

* Change any calls to `run.tests()` to calls to `test.project()`. `run.tests()` has now been removed permanently from ProjectTemplate.

##### Updating a v0.3-1 Project to a v0.3-3 Project

* Rename `lib/utilities.R` to `lib/helpers.R`. This is not required in any way, but it will make your project seem like a v0.3-3 project.

##### Updating a v0.2-1 Project to a v0.3-1 Project

* Replace any configuration file written in YAML with DCF files.
  * Remove all the quote marks from your settings (i.e. munging: 'on' => munging: on)
  * Collapse your libraries onto a single line separated by commas (i.e. libraries: ggplot2, stringr)
  * `global.yaml` needs to be renamed `global.dfc`.
  * Any `.url` or `.sql` files you've written in YAML need to be converted to DCF syntax.
* Remove the `clean.variable.name` and `cache.name` functions from `helpers.R`.

##### Updating a v0.1-3 Project to a v0.3-1 Project

* Create the new ProjectTemplate directories you're missing. It's probably easiest to make a new empty project and copy the missing directories from the empty project into your existing project.
  * `create.project('tmp')`
  * `mv tmp/cache/ .`
  * `mv tmp/config/ .`
  * `mv tmp/diagnostics/1.R diagnostics`
  * `mv tmp/munge .`
  * `mv tmp/src .`
  * `rm -rf tmp`
* Move any preprocessing steps from `lib/preprocess_data.R` into a file in `munge`, preferably the `1-A.R` script.
* Edit the new configuration file in `config/global.dcf`. You'll want to specify the R packages you'll load and change the `load_libraries` setting to `on`.
* Get rid of old scripts from the `lib` directory that are no longer being used:
  * `rm lib/boot.R`
  * `rm lib/load_data.R`
  * `rm lib/load_libraries.R`
  * `rm lib/preprocess_data.R`
  * `rm lib/run_tests.R`
  * `rm lib/helpers.R`
