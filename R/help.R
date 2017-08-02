#' Automates the creation of new statistical analysis projects.
#'
#' ProjectTemplate provides functions to automatically build a directory
#' structure for a new R project. Using this structure, ProjectTemplate
#' automates data loading, preprocessing, library importing and unit
#' testing.
#'
#' @references This code is inspired by the skeleton structure used by
#'   Ruby on Rails.
#' @docType package
#' @name ProjectTemplate
#' @aliases ProjectTemplate package-ProjectTemplate
#' @examples
#' library('ProjectTemplate')
#'
#' \dontrun{create.project('project_name')
#'
#' setwd('project_name')
#' load.project()}
#'

## quiets concerns of R CMD check re: the config variables that appear in readers
if(getRversion() >= "2.15.1")  utils::globalVariables(c("config"))
NULL
