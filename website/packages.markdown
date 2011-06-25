# ProjectTemplate is Not Meant to Help You Build an R Package

ProjectTemplate is not designed to help you write R packages. If you're
looking to do that, you should start by looking at the `package.skeleton()`
function provided by the `utils` package. In the future, we hope that there
will be better tools for building packages in R, but the ProjectTemplate
team probably won't be building those sort of tools anytime soon.

If it's not clear to you why ProjectTemplate isn't meant to help you write
your own package, here are some important ways in which a statistical analysis
project differs from a package:

* A project is built around exactly one data set, while a package should work with many different data sets.
* A project is something specific: your goal is to learn a specific fact about the world from a specific data set. In contrast, a package should contain general purpose tools for analyzing many different data sets. For example, a package might contain code to perform linear regression, while a project would contain code that performs linear regression on a specific set of variables, such as height and annual income.
