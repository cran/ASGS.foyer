context("test-install_asgs.R")

test_that("Installation OK", {
  skip_on_cran()
  .tempf <- tempfile("01")
  file.create(.tempf)
  tempf <- normalizePath(.tempf, winslash = "/")
  skip_if(dir.exists(tempf))
  dir.create(tempf)
  install_notpossible <-
    tryCatch(install.packages("TeXCheckR", lib = tempf),
             error = function(e) {
               TRUE
             })
  if (!is.null(install_notpossible) && install_notpossible) {
    skip("Unable to try install")
  } else {
    tryCatch(install_ASGS(lib = tempf, verbose = TRUE),
             error = function(e) {
               cat("spdep: ", as.character(requireNamespace("spdep", quietly = TRUE)), "\n",
                   tempf, "\n")
               stop(e$m)
             })
    expect_true(TRUE)
  }
})

test_that("Installation when using repos OK", {
  skip_on_cran()
  skip_if(file.exists("abc.tar.gz"))
  skip_if_not(getRversion() == "3.4.3")
  tempf <- tempfile("002")
  dir.create(tempf)
  install_ASGS(temp.tar.gz = "abc.tar.gz",
               repos = "https://mran.microsoft.com/snapshot/2018-01-01",
               lib = tempf,
               quiet = TRUE)
  file.exists("abc.tar.tz")
  expect_true(file.remove("abc.tar.tz"))
})

test_that("All arguments have an effect", {
  expect_null(codetools::checkUsage(install_ASGS, all = TRUE))
})
