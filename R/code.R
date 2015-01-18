#' Parse a darwin core file
#'
#' @export
#' @import XML
#'
#' @param file A darwin core file
#' @examples \dontrun{
#' file <- system.file("examples", "example_simple.xml", package = "finch")
#' beak(file)
#' file <- system.file("examples", "example_simple_fossil.xml", package = "finch")
#' beak(file)
#' }

beak <- function(file){
  if( !file.exists(file) ) stop("That file does not exist", call. = FALSE)
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
  structure(list(meta = meta, dc = dc, dwc = dwc), class="darwincore")
}
