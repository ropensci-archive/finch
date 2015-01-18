#' Convert a path or URL to a location object.
#'
#' @export
#'
#' @param x Input.
#' @param ... Ignored.
#' @examples \donttest{
#' # A zip file
#' file <- "~/Downloads/0000154-150116162929234.zip"
#' as.location(file)
#'
#' # A directory
#' dir <- "~/Downloads/0000154-150116162929234/"
#' as.location(dir)
#'
#' # A URL
#' url <- "http://ecat-dev.gbif.org/repository/vernaculars/vernacular_registry_dwca_3.zip"
#' as.location(url)
#' }

as.location <- function(x, ...) UseMethod("as.location")

#' @export
#' @rdname as.location
as.location.character <- function(x, ...) check_location(x, ...)

#' @export
#' @rdname as.location
as.location.location <- function(x, ...) x

check_location <- function(x, ...){
  if(is.url(x)){
    as_location(x, "url")
  } else {
    if( !file.exists(x) ) stop("File does not exist. Create it, or fix the path.")
    if( file.info(x)$isdir )
      as_location(path.expand(x), "dir")
    else
      as_location(path.expand(x), "file")
  }
}

as_location <- function(x, type){
  structure(x, class="location", type=type)
}

#' @export
#' @rdname as.location
print.location <- function(x, ...){
  cat("<location>", "\n")
  cat("   Type: ", attr(x, "type"), "\n")
  cat("   Location: ", x[[1]], "\n")
}

is.url <- function(x, ...){
  grepl("https?://", x)
}
