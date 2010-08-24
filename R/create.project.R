create.project <-
function(project.name)
{
  sub.directories <- c('data', 'diagnostics', 'doc', 'graphs', 'lib', 'profiling', 'reports', 'tests')
  special.files <- c('README', 'TODO')
  
  dir.create(project.name)
  
  for (sub.directory in sub.directories)
  {
    dir.create(file.path(project.name, sub.directory))
  }
  
  for (special.file in special.files)
  {
    file.create(file.path(project.name, special.file))
  }
  
  file.create(file.path(project.name, 'lib', 'preprocess_data.R'))
  
  file.copy(system.file(file.path('defaults', 'boot.R'), package = 'ProjectTemplate'),
            file.path(project.name, 'lib', 'boot.R'))
  file.copy(system.file(file.path('defaults', 'load_data.R'), package = 'ProjectTemplate'),
            file.path(project.name, 'lib', 'load_data.R'))
  file.copy(system.file(file.path('defaults', 'load_libraries.R'), package = 'ProjectTemplate'),
            file.path(project.name, 'lib', 'load_libraries.R'))
  file.copy(system.file(file.path('defaults', 'utilities.R'), package = 'ProjectTemplate'),
            file.path(project.name, 'lib', 'utilities.R'))
}
