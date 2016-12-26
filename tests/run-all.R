library(testthat)


# Save the current root template configuration
assign("root_template",  ProjectTemplate:::.backup.root.template(tempdir()), envir = baseenv())

# remove the configuration before running the tests
ProjectTemplate:::.clear.root.template()

# Run the tests and restore the root config afterwards
tryCatch(
         test_check("ProjectTemplate"), 
         error = function (e) {
                 
                 message(paste0(e))
         },
         finally = {
                 # restore the root template configuration
                 ProjectTemplate:::.restore.root.template(root_template)
                 
                 # tidy up
                 unlink(root_template)
                 suppressMessages(clear(force=TRUE))
         }
)

