#' Validate a Darwin Core Archive
#'
#' @export
#'
#' @param x (character) A url for a Darwin Core Archive. If you have a local
#' Darwin Core Archive, put it up online somewhere. Required.
#' @param ifModifiedSince (character) An optional ISO date (yyyy-mm-dd) to
#' enable conditional get requests, validating archives only if they have
#' been modified since the given date. This feature requires the archive url
#' to honor the if-modified-since http header. Apache webservers for example
#' do this out of the box for static files, but if you use dynamic scripts
#' to generate the archive on the fly this might not be recognised. Optional.
#' @param browse (logical) Browse to generated report or not.
#' Default: \code{FALSE}
#' @param ... Curl options passed to \code{\link[httr]{GET}}
#' @details Uses the GBIF DCA validator (http://tools.gbif.org/dwca-validator/)
#'
#' @examples \dontrun{
#' x <- "http://rs.gbif.org/datasets/german_sl.zip"
#' dwca_validate(x)
#' }
dwca_validate <- function(x, ifModifiedSince = NULL, browse = FALSE, ...) {
  checkforpkg("httr")
  checkforpkg("jsonlite")
  if (!is.character(x)) stop(x, " must be character class", call. = FALSE)
  if (!is.url(x)) stop(x, " does not appear to be a URL", call. = FALSE)
  args <- fcmp(list(archiveUrl = x, ifModifiedSince = ifModifiedSince))
  res <- httr::GET(gbif_val(), query = args)
  httr::stop_for_status(res)
  tmp <- httr::content(res, "text")
  dat <- jsonlite::fromJSON(tmp)
  if (browse) utils::browseURL(dat$report) else dat
}

gbif_val <- function() "http://tools.gbif.org/dwca-validator/validatews.do"
