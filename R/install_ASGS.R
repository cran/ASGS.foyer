#' Install a (nearly) complete package of the Australian Statistical Geography Standard
#' @param temp.tar.gz A file to save the ASGS tarball. Since the package is quite large,
#' it may be prudent to set this to a non-temporary file so that you can attempt reinstallation.
#' @param ... Arguments passed to \code{\link[utils]{install.packages}}.
#' @export

install_ASGS <- function(temp.tar.gz = tempfile(fileext = ".tar.gz"), ...) {
  message("Attempting install of ASGS (700 MB) from Dropbox. This should take some minutes to download.")
  tempf <- tempfile(fileext = ".tar.gz")
  utils::download.file(url = "https://dl.dropbox.com/s/zmggqb1wmmv7mqe/ASGS_0.4.0.tar.gz",
                       destfile = tempf)
  utils::install.packages(tempf, type = "source", repos = NULL, ...)
}
