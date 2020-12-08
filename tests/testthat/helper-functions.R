# Function to tidy up at the end of tests
tidy_up <- function() {
  objs <- setdiff(ls(envir = .TargetEnv), "tidy_up")
  rm(list = objs, envir = .TargetEnv)
}
