ProjectTemplate v0.3-5 is currently on [CRAN](http://cran.r-project.org/web/packages/ProjectTemplate/) and can be installed using a simple call to `install.packages()`:

    install.packages('ProjectTemplate')

If you would like take advantage of changes to this package that are not available in the version on CRAN, please download the contents of the [GitHub repository](https://github.com/johnmyleswhite/ProjectTemplate) and then run,

    R CMD INSTALL ProjectTemplate_*.tar.gz

For inexperienced users, running the bleeding edge version of ProjectTemplate is probably a mistake. It is generally less stable than the versions that have been released on CRAN and is usually a little out of sync with the documentation. That said, if you'd like to use the most recent version of ProjectTemplate and don't quite understand how to use `R CMD INSTALL`, you can also install the [`devtools`](http://cran.r-project.org/web/packages/devtools/index.html) package from CRAN and then type

    install_github('ProjectTemplate', username = 'johnmyleswhite')

to install ProjectTemplate from source.
