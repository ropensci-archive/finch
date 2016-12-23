#' Parse a DarwinRecordSet and SimpleDarwinRecordSet files
#'
#' @export
#' @param file (character) A path to a single simple Darwin Core
#' file in XML format. Required.
#'
#' @return a S3 class \code{dwc_recordset} when a DarwinRecordSet is given, or
#' a \code{dwc_simplerecordset} when a SimpleDarwinRecordSet is given. In
#' each case the object is really just a list, with lightweight S3 class
#' attached for easy downstream usage. Prints summary to screen by default
#'
#' @details Make sure when reading a DarwinRecordSet to access the chunks by
#' position rather than name since duplicate names are allowed in chunks.
#'
#' @examples
#' # SimpleDarwinRecordSet examples
#' file <- system.file("examples", "example_simple.xml", package = "finch")
#' simple_read(file)
#' file <- system.file("examples", "example_simple_fossil.xml",
#'   package = "finch")
#' simple_read(file)
#'
#' # DarwinRecordSet examples
#' file <- system.file("examples", "example_classes_observation.xml",
#'   package = "finch")
#' simple_read(file)
#'
#' file <- system.file("examples", "example_classes_specimen.xml",
#'   package = "finch")
#' simple_read(file)
#'
#' # access elements of the object
#' file <- system.file("examples", "example_classes_specimen.xml",
#'   package = "finch")
#' res <- simple_read(file)
#' ## namespaces
#' res$meta
#' ## locations
#' res$locations
#' ## chunks, the first one
#' res$chunks[[1]]
simple_read <- function(file) {
  if (!file.exists(file)) stop("file does not exist", call. = FALSE)
  xml <- read_xml(file)
  rt <- xml_name(xml_root(xml))
  meta <- lapply(xml_ns(xml), function(x) unlist(x))
  if (tolower(rt) == "darwinrecordset") {
    locs <- xml_find_all(xml, "//dcterms:Location//dwc:*")
    locs <- lapply(locs, function(x) {
      as.list(stats::setNames(xml_text(x), xml_name(x)))
    })
    res <- xml_find_all(xml, "dwc:*")
    chunks <- stats::setNames(lapply(res, function(x) {
      unlist(lapply(xml_children(x), function(z) {
        as.list(stats::setNames(xml_text(z), xml_name(z)))
      }), recursive = FALSE)
    }), xml_name(res))
    structure(list(meta = meta, locations = locs,
                   chunks = chunks), class = "dwc_recordset")
  } else if (tolower(rt) == "simpledarwinrecordset") {
    dc <- fetch_ns("dc", meta, xml)
    dwc <- fetch_ns("dwc", meta, xml)
    structure(list(meta = meta, dc = dc, dwc = dwc),
              class = "dwc_simplerecordset")
  } else {
    stop("no parser for ", rt, call. = FALSE)
  }
}

fetch_ns <- function(ns, meta, xml) {
  if (ns %in% names(meta)) {
    dwc <- xml_find_all(xml, sprintf("//%s:*", ns))
    lapply(dwc, function(x) {
      as.list(stats::setNames(xml_text(x), xml_name(x)))
    })
  } else {
    list()
  }
}

#' @export
print.dwc_simplerecordset <- function(x, ...){
  cat("<dwc SimpleDarwinRecordSet>", sep = "\n")
  cat("  meta >", sep = "\n")
  for (i in seq_along(x$meta)) {
    cat(sprintf("    %s: %s", names(x$meta[i]), x$meta[[i]]), sep = "\n")
  }
  cat("  dc >", sep = "\n")
  for (i in seq_along(x$dc)) {
    cat(sprintf("    %s: %s", names(x$dc[[i]]), x$dc[[i]][[1]]), sep = "\n")
  }
  cat("  dwc >", sep = "\n")
  for (i in seq_along(x$dwc)) {
    cat(sprintf("    %s: %s", names(x$dwc[[i]]), x$dwc[[i]][[1]]), sep = "\n")
  }
}

#' @export
print.dwc_recordset <- function(x, ...){
  cat("<dwc DarwinRecordSet>", sep = "\n")
  cat("  meta >", sep = "\n")
  for (i in seq_along(x$meta)) {
    cat(sprintf("    %s: %s", names(x$meta[i]), x$meta[[i]]), sep = "\n")
  }
  cat("  locations >", sep = "\n")
  for (i in seq_along(x$locations)) {
    cat(sprintf("    %s: %s", names(x$locations[[i]]), x$locations[[i]][[1]]),
        sep = "\n")
  }
  cat("  chunks >", sep = "\n")
  for (i in seq_along(x$chunks)) {
    cat(sprintf("    %s >", names(x$chunks)[i]), sep = "\n")
    cat(sprintf("      %s: %s", names(x$chunks[[i]]), x$chunks[[i]][[1]]),
        sep = "\n")
  }
}
