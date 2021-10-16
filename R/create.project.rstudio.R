create_project_rstudio <- function(path, template, dump, merge)
{

  .stopifproject(c("Cannot create a new project inside an existing one",
                   "Please change to another directory and re-run create.project()"),
                 path = normalizePath(dirname(path)))

  .stopifproject(c("Cannot create a new project inside an existing one",
                   "Please change to another directory and re-run create.project()"),
                 path = dirname(normalizePath(dirname(path))))

  dir.create(path, recursive = TRUE, showWarnings = FALSE)



  ProjectTemplate::create.project(
    project.name = path, template = template,
    dump = dump, merge.strategy = ifelse(merge, "allow.non.conflict", "require.empty"),
    rstudio.project = TRUE
  )
}
