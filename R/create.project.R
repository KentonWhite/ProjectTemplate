create.project <- function(project.name, minimal = FALSE, dump = FALSE)
{
  tmp.dir <- paste(project.name, '_tmp', sep = '')

  if (file.exists(project.name) || file.exists(tmp.dir))
  {
    stop(paste("Cannot run create.project() from a directory containing", project.name, "or", tmp.dir))
  }

  dir.create(tmp.dir)

  if (minimal)
  {
    file.copy(system.file(file.path('defaults', 'minimal'), package = 'ProjectTemplate'),
              file.path(tmp.dir),
              recursive = TRUE)
    file.rename(file.path(tmp.dir, 'minimal'),
                project.name)
  }
  else
  {
    file.copy(system.file(file.path('defaults', 'full'), package = 'ProjectTemplate'),
              file.path(tmp.dir),
              recursive = TRUE)
    file.rename(file.path(tmp.dir, 'full'),
                project.name)
  }
  
  if (dump)
  {
    1; # Magic happens here to place all of the R files from ProjectTemplate in the current folder.
  }

  unlink(tmp.dir, recursive = TRUE)
}
