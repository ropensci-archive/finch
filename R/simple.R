#' Parse a simple darwin core file
#'
#' @export
#' @param file (character) A path to a single simple Darwin Core file in XML format
#' @examples \dontrun{
#' file <- system.file("examples", "example_simple.xml", package = "finch")
#' simple_read(file)
#' file <- system.file("examples", "example_simple_fossil.xml", package = "finch")
#' simple_read(file)
#' file <- system.file("examples", "example_simple_fossil.xml", package = "finch")
#' simple_read(file)
#' }
simple_read <- function(file){
  if ( !file.exists(file) ) stop("That file does not exist", call. = FALSE)
  xml <- xmlParse(file)
  dc <- xpathSApply(xml, "//dc:*")
  dc <- lapply(dc, function(x){
    as.list(setNames(xmlValue(x), xmlName(x)))
  })
  dwc <- xpathSApply(xml, "//dwc:*")
  dwc <- lapply(dwc, function(x){
    as.list(setNames(xmlValue(x), xmlName(x)))
  })
  meta <- sapply(xmlNamespaces(xml), function(x) unname(as.list(setNames(x$uri, x$id))))
  structure(list(meta = meta, dc = dc, dwc = dwc), class = "dwc_simple")
}

#' @export
print.dwc_simple <- function(x, ...){
  cat("<dwc simple>", sep = "\n")
  cat("  meta", sep = "\n")
  for (i in seq_along(x$meta)) {
    cat(sprintf("    %s: %s", names(x$meta[i]), x$meta[[i]]), sep = "\n")
  }
  cat("  dc", sep = "\n")
  for (i in seq_along(x$dc)) {
    cat(sprintf("    %s: %s", names(x$dc[[i]]), x$dc[[i]][[1]]), sep = "\n")
  }
  cat("  dwc", sep = "\n")
  for (i in seq_along(x$dwc)) {
    cat(sprintf("    %s: %s", names(x$dwc[[i]]), x$dwc[[i]][[1]]), sep = "\n")
  }
}
