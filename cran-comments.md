## Test environments
* local MacOSX x86_64-apple-darwin22.6.0 (64-bit) install, R version 4.3.2 (2023-10-31)
* ubuntu 20.04.1 LTS, R version 4.3.2 (2023-10-31)
* Fedora Linux, R-devel, clang, gfortran
* Windows Server 2022, R-devel, 64 bit

## R CMD check results

Therea are 2 NOTEs that is only found on Windows (Server 2022, R-devel 64-bit):

```
* checking for non-standard things in the check directory ... NOTE
Found the following files/directories:
  ''NULL''
```

As noted in [R-hub issue #503](https://github.com/r-hub/rhub/issues/560), this is "probably an R-hub thing, so you can ignore it."

 ```
 * checking for detritus in the temp directory ... NOTE
 Found the following files/directories:
   'lastMiKTeXException'
 ```
 As noted in [R-hub issue #503](https://github.com/r-hub/rhub/issues/503), this could be due to a bug/crash in MiKTeX and can likely be ignored.

## Reverse dependencies

Checked 1 reverse dependency and saw one ner problem:

* ptspotter

The Maintainer has been notified

