## Test environments
* local MacOSX install, R-devel 3.6
* ubuntu 12.04 (on travis-ci), R 3.5.2
* win-builder (devel and release)

## R CMD check results

There is one NOTE that is only found on Windows (Server 2022, R-devel 64-bit): 

 ```
 * checking for detritus in the temp directory ... NOTE
 Found the following files/directories:
   'lastMiKTeXException'
 ```
 As noted in [R-hub issue #503](https://github.com/r-hub/rhub/issues/503), this could be due to a bug/crash in MiKTeX and can likely be ignored.

## Reverse dependencies

* I have checked the one downstream dependency is not broken