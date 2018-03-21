#' Determine whether coordinates lie in a given statistical area.
#' @param lat,lon Numeric vector representing coordinates in decimal degrees. Coordinates south of the equator have \code{lat < 0}.
#' @param to The statistical area to convert to.
#' @param yr The year of the statistical area.
#' @param return Whether to return an atomic vector \code{(v)} representing the shapefile for each point \code{lat, lon} or a spatial points object from package \code{sp}.
#' @param NAME (logical, default: \code{TRUE}) whether to use the name or number of the statistical area
#' @param .shapefile If specified, an arbitrary shapefile containing the statistical areas to locate.
#' @return The statistical area that contains each point.
#' @examples
#' latlon2SA(-35.3, 149.2, to = "STE", yr = "2016")
#' @importFrom methods is
#' @export

latlon2SA <- function(lat,
                      lon,
                      to = c("STE", "SA2", "SA1", "SA3", "SA4"),
                      yr = c("2016", "2011"),
                      return = c("v", "sp"),
                      NAME = TRUE,
                      .shapefile = NULL) {
  if (is.null(.shapefile)) {
    # Could use NSE but can't be arsed:
    to <- match.arg(to)

    if (to != "STE" && !isNamespaceLoaded("ASGS")) {
      stop("The ASGS package is required for any statistical area besides 2016")
    }

    yr <- match.arg(yr)
    if (yr != "2016" && !isNamespaceLoaded("ASGS")) {
      stop("The ASGS package is required for `year = 2011`.")
    }

    return <- match.arg(return)
    stopifnot(length(to) == 1,
              length(yr) == 1,
              length(lat) == length(lon))

    if (to != "STE" && !isNamespaceLoaded("ASGS")) {
      shapefile <- get(paste0(to, "_", yr))
    } else {
      shapefile <- ASGS.foyer::STE_2016_simple
    }
  } else {
    shapefile <- .shapefile
    stopifnot("proj4string" %in% methods::slotNames(shapefile),
              "data" %in% methods::slotNames(shapefile))
  }
  if (!is(shapefile, "SpatialPolygonsDataFrame")) {
    stop("Attempted to retrieve `", paste0(to, "_", yr), "` internally ",
         "but that object is not a SpatialPolygonsDataFrame. Due to ",
         "limitations of this function, ensure that this object ",
         "does not exist except as the shapefile from the ASGS package.")
  }
  points <- sp::SpatialPoints(coords = sp::coordinates(data.frame(x = lon, y = lat)),
                              proj4string = shapefile@proj4string)
  out <- sp::over(points, shapefile)

  if (return == "v") {
    if (NAME && to != "SA1") {
      suffix <- paste0("NAME", substr(yr, 3, 4))
      v_name <- paste0(to, "_", suffix)
    } else {
      suffix <- names(out)[grepl(to, names(out)) & !grepl("NAME", names(out))]
      v_name <- suffix[1]
    }
    out <- out[[v_name]]
  }
  out
}


