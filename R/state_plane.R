#' State Plane Projections
#'
#' Get the State Plane projection for a specific state or region within a state.
#'
#' @param state The state code.
#' @param plane_id The state plane geographic zone identifier. A \code{NULL}
#'   value will return a projection for the entire state.
#' @param type A string identifying the output as either an EPSG code or PROJ4
#'   string.
#'
#' @return Either a PROJ4 string as a character vector or an EPSG code as an
#'   integer.
#'
#' @seealso For documentation of the underlying state plane projection data
#'   frame, see \code{\link{state_proj}}.
#'
#' @examples
#' state_plane (state = "MA", type = "epsg")
#' state_plane (state = "MA", plane_id = "mainland", type = "proj4")
#'
#' @export
state_plane <- function(state, plane_id = NULL, type = c("epsg", "proj4")) {
  type <- match.arg(type)
  stopifnot(state %in% unique(state_proj$state))
  state_regions <- state_proj[state_proj$state == state, ]
  if (!is.null(plane_id)) {
    plane_id <- tolower(plane_id)
  }
  stopifnot(is.null(plane_id) || plane_id %in% unique(state_regions$zone))
  if (is.null(plane_id) && type == "epsg") {
    item <- state_proj[["epsg"]][state_proj$state == state & state_proj$statewide_proj == TRUE]
    item <- as.integer(item)
  } else if (is.null(plane_id) && type == "proj4") {
    item <- state_proj[["proj4_string"]][state_proj$state == state & state_proj$statewide_proj == TRUE]
  } else if (type == "epsg") {
    item <- state_proj[["epsg"]][state_proj$state == state & state_proj$zone == plane_id]
    item <- as.integer(item)
  } else if (type == "proj4") {
    item <- state_proj[["proj4_string"]][state_proj$state == state & state_proj$zone == plane_id]
  }
  item
}
