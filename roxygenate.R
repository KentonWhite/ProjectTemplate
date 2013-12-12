#!/usr/bin/env Rscript
unlink(c("NAMESPACE", "man"), recursive = TRUE)
library('roxygen2')
roxygenize('.')
