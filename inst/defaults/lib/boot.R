cat('Autoloading utility functions\n')
source('lib/utilities.R')
cat('Autoloading libraries\n')
source('lib/load_libraries.R')
cat('Autoloading data\n')
# Execute load_data.R in a throw-away environment so data loading functions
# do not pollute the global environment.
local(source('lib/load_data.R', local=TRUE))
cat('Preprocessing data\n')
source('lib/preprocess_data.R')

# Need to discuss automatic log4r usage on the mailing list.
#logger <- create.logger()
#logfile(logger) <- file.path('logs', 'project.log')
#level(logger) <- log4r:::INFO
#info(logger, 'Data analysis session started.')
