create.project <- function(project.name)
{
  tmp.dir <- paste(project.name, '_tmp', sep = '')

  if (file.exists(project.name) || file.exists(tmp.dir))
  {
    stop(paste("Cannot run create.project() from a directory containing", project.name, "or", tmp.dir))
  }
  
  dir.create(tmp.dir)
  
  file.copy(system.file('defaults', package = 'ProjectTemplate'),
            file.path(tmp.dir),
            recursive = TRUE)
            
  file.rename(file.path(tmp.dir, 'defaults'),
              project.name)
  
  unlink(tmp.dir, recursive = TRUE)
}
