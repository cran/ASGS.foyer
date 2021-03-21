[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/HughParsonage/ASGS.foyer?branch=master&svg=true)](https://ci.appveyor.com/project/HughParsonage/ASGS.foyer)

# ASGS.foyer

## ASGS.foyer 0.3.1
* Use `NULL` as default for `url.tar.gz` to avoid overflow

## ASGS.foyer 0.3.0
* Add SLA 2006 centroids (2018-09-03)
* Update dropbox link to GitHub

## ASGS.foyer 0.2.1
* Added `codetools` and `spdep` to Suggests as they are used in tests. Thanks to CRAN for notifying.


## ASGS.foyer 0.2.0

* `install_ASGS`: if one of ASGS's dependencies is not installed, `install_ASGS` now installs it rather than raising an error *after* the download has taken place. By default, the packages are installed then a second attempt at installation occurs 
* `temp.tar.gz` now is actually used, rather than having no effect. Thanks to BV for reporting.

## ASGS.foyer 0.1.0

* Added a `NEWS.md` file to track changes to the package.
