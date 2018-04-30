#' Install a (nearly) complete package of the Australian Statistical Geography Standard
#' @description The ASGS package provides a nearly comprehensive set of shapefiles, both unmodified and simplified from the Australian Bureau of Statistics. The ASGS package is over 700 MB, so cannot be hosted on CRAN. This function allows the package to be distributed almost as conveniently as through CRAN.
#'
#' Should you find ASGS lacks some shapefile that you require, please file an issue requesting it be added.
#'
#' Note that the package is quite large and provides no limits on access, so it is preferred that distribution occur as far as possible via other channels to ensure the method of access provided here is sustainable.
#' @param temp.tar.gz A file to save the ASGS tarball after download. Since the package is quite large,
#' it may be prudent to set this to a non-temporary file so that subsequent attempts to reinstall do not require additional downloads.
#' @param overwrite (logical, default: \code{FALSE}). If \code{temp.tar.gz} already exists, should it be overwritten or should there be an error?
#' @param lib,repos,type Passed to \code{\link[utils]{install.packages}} when installing ASGS's dependencies (if not already installed).
#' @param ... Other arguments passed to \code{\link[utils]{install.packages}}.
#' @param .reinstalls Number of times to attempt to install any (absent) dependencies of \code{ASGS}
#' before aborting. Try restarting R rather than setting this number too high.
#' @param verbose (logical, default: \code{FALSE}) Report logic paths?
#' @return \code{temp.tar.gz}, invisibly.
#' @export

install_ASGS <- function(temp.tar.gz = tempfile(fileext = ".tar.gz"),
                         overwrite = FALSE,
                         lib = .libPaths()[1],
                         repos = getOption("repos"),
                         type = getOption("pkgType", "source"),
                         ...,
                         .reinstalls = 4L,
                         verbose = FALSE) {
  tempf <- temp.tar.gz
  if (file.exists(tempf)) {
    if (!identical(overwrite, FALSE) && !isTRUE(overwrite)) {
      stop("`overwrite = ", deparse(substitute(overwrite)), "` but must be TRUE or FALSE.")
    }
    if (!overwrite) {
      stop(temp.tar.gz, " exists, yet `overwrite = FALSE`.")
    }
    if (overwrite && !file.remove(tempf)) {
      stop("Unable to overwrite ", tempf)
    }
  }

  asgs_deps <-
    c("dplyr", "leaflet", "sp",
      "htmltools", "magrittr",
      "rgdal", "data.table", "hutils",
      "spdep")

  absent_deps <- function(deps = asgs_deps) {
    deps[!vapply(deps, requireNamespace,
                 lib.loc = lib, quietly = TRUE,
                 FUN.VALUE = logical(1L))]
  }

  reinstalls <- .reinstalls
  backoff <- 2
  while (reinstalls > 0L && length(absent_deps())) {
    reinstalls <- reinstalls - 1L
    backoff <- 2 * backoff
    message("Attempting to install the following uninstalled dependencies of ASGS:",
            paste0(absent_deps(), collapse = " "), ".\n",
            reinstalls, " reinstalls remaining.")
    Sys.sleep(backoff)
    if (backoff > 10) {
      message("Waiting ", backoff, " seconds before attempting to reinstallation.",
              "Wait times double on each reattempt as a courtesy to repository maintainers.")
    }
    r <- repos

    if (identical(r["CRAN"], "@CRAN@")) {
      if (verbose) cat("AAAA\n")
      message("Setting CRAN repository to https://rstudio.cran.com")
      utils::install.packages(absent_deps(),
                              lib = lib,
                              repos = "https://rstudio.cran.com",
                              type = "source",
                              contrib.url = "https://rstudio.cran.com/src/contrib",
                              ...)
    } else if ("@CRAN@" %in% repos) {
      if (verbose) cat("BBBB\n")
      options(repos = c(CRAN = "https://cran.ms.unimelb.edu.au/"))
      utils::install.packages(absent_deps(),
                              repos =  c(CRAN = "https://cran.ms.unimelb.edu.au/"),
                              type = type,
                              lib = lib,
                              ...)
    } else {
      if (verbose) cat("CCCC\n")
      utils::install.packages(absent_deps(),
                              repos = repos,
                              lib = lib,
                              type = type,
                              ...)
    }
  }

  if (length(absent_deps())) {
    stop("ASGS requires the following packages: ",
         paste0(absent_deps(), collapse = " "),
         ". ",
         "Attempts to install did not succeed. Aborting before (lengthy) download.")
  }

  message("Attempting install of ASGS (700 MB) from Dropbox. ",
          "This should take some minutes to download.")

  utils::download.file(url = "https://dl.dropbox.com/s/zmggqb1wmmv7mqe/ASGS_0.4.0.tar.gz",
                       destfile = tempf)
  utils::install.packages(tempf,
                          lib = lib,
                          type = "source",
                          repos = NULL,
                          ...)
  invisible(tempf)
}
