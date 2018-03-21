context("test-latlon2sa.R")

test_that("Example works", {
  expect_equal(as.character(latlon2SA(-35.3, 149.2, to = "STE", yr = "2016")),
               "Australian Capital Territory")
})

test_that("Multiple", {
  lat <- c(-36.069, -35.3)
  lon <- c(146.9509 , 149.2)
  expect_equal(as.character(latlon2SA(lat, lon, to = "STE", yr = "2016")),
               c("New South Wales", "Australian Capital Territory"))
})
