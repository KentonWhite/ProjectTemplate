#' Load Project
#'
#' Call this function as an addin to load the library and run `load.project()`
#'
#' @export
loadproject_addin <- function(){
  require(ProjectTemplate)
  load.project()
}

#' Reload Project
#'
#' Call this function as an addin to load the library and run `reload.project()`
#'
#' @export
reloadproject_addin <- function(){
  require(ProjectTemplate)
  reload.project()
}
