---
layout: page
---
The current configuration settings exist in the `config/global.dcf` file:

* `data_loading`: This can be set to 'on' or 'off'. If `data_loading` is on, the system will load data from both the `cache` and `data` directories with `cache` taking precedence in the case of name conflict. By default, `data_loading` is on.
* `munging`: This can be set to 'on' or 'off'. If `munging` is on, the system will execute the files in the `munge` directory sequentially using the order implied by the `sort()` function. If `munging` is off, none of the files in the `munge` directory will be executed. By default, `munging` is on.
* `logging`: This can be set to 'on' or 'off'. If `logging` is on, a logger object using the `log4r` package is automatically created when you run `load.project()`. This logger will write to the `logs` directory. By default, `logging` is off.
* `load_libraries`: This can be set to 'on' or 'off'. If `load_libraries` is on, the system will load all of the R packages listed in the `libraries` field described below. By default, `load_libraries` is off.
* `libraries`: This is a comma separated list of all the R packages that the user wants to automatically load when `load.project()` is called. These packages must already be installed before calling `load.project()`. By default, the reshape, plyr, ggplot2, stringr and lubridate packages are included in this list.
* `as_factors`: This can be set to 'on' or 'off'. If `as_factors` is on, the system will convert every character vector into a factor when creating data frames; most importantly, this automatic conversion occurs when reading in data automatically. If 'off', character vectors will remain character vectors. By default, `as_factors` is on.
* `data_tables`: This can be set to 'on' or 'off'. If `data_tables` is on, the system will convert every data set loaded from the `data` directory into a `data.table`. By default, `data_tables` is off.

The following configuration settings still require documentation:
* `cache_loading`
* `recursive_loading`
* `attach_internal_libraries`
