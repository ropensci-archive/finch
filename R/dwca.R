#' Parse Darwin Core Archive
#'
#' @export
#'
#' @param input (character) Path to local zip file, directory, or a url.
#' If a URL it must be for a zip file.
#' @param read (logical) Whether or not to read in data files. If \code{FALSE},
#' we give back paths to files only. Default: \code{FALSE}
#' @param ... Further args passed on to \code{\link[data.table]{fread}}
#'
#' @details
#' Note that sometimes file reads fail. We use \code{\link[data.table]{fread}}
#' internally, which is very fast, but can fail sometimes. If so, try reading
#' in the data manually.
#'
#' When you pass in a URL, we use \pkg{rappdirs} to determine cache path, and
#' if you pass the same URL again, and your cache is not cleared, we'll
#' pull from the cache. Passing a file or directory on your local system
#' won't invoke the caching route, but will go directly to the file/directory.
#'
#' @examples
#' dir <- system.file("examples", "0000154-150116162929234", package = "finch")
#'
#' # Don't read data in
#' (x <- dwca_read(dir, read=FALSE))
#' x$files
#' x$highmeta
#' x$dataset_meta[[1]]
#' x$data
#'
#' \dontrun{
#' # Read data
#' (x <- dwca_read(dir, read=TRUE))
#' head(x$data[[1]])
#'
#' # Can pass in a zip file
#' zip <- system.file("examples", "0000154-150116162929234.zip",
#'   package = "finch")
#' (out <- dwca_read(zip))
#' out$files
#' out$highmeta
#' out$emlmeta
#' out$dataset_meta
#'
#' # Can pass in zip file as a url
#' url <-
#'"https://github.com/ropensci/finch/blob/master/inst/examples/0000154-150116162929234.zip?raw=true"
#' (out <- dwca_read(url))
#'
#' # another url
#' url <- "http://ipt.jbrj.gov.br/jbrj/archive.do?r=redlist_2013_taxons&v=3.12"
#' (out <- dwca_read(url))
#' }

dwca_read <- function(input, read = FALSE, ...){
  # check file type
  x <- as.location(input)
  x <- process(x)
  # get file names and paths
  files <- parse_dwca(x)
  # high level metadata - meta.xml file
  highmeta <- try_meta(files$xml_files)
  # high level metadata - eml.xml or other named eml file
  emlmeta <- try_eml(files$xml_files)
  # get datasets metadata
  dataset_meta <- lapply(files$datasets_meta, EML::read_eml)
  # get data
  datout <- read_data(files$data_paths, read)

  structure(list(files = files,
                 highmeta = highmeta,
                 emlmeta = emlmeta,
                 dataset_meta = dataset_meta,
                 data = datout), class = "dwca_gbif", read = read)
}

try_meta <- function(x) {
  tmp <- read_xml(grep("meta.xml", x, value = TRUE))
  xml_ns_strip(tmp)

  core <- xml_find_first(tmp, "//archive/core")
  if (inherits(core, "xml_missing")) {
    occ_file <- "core"
    occ_df <- list()
  } else {
    occ_file <- xml_text(xml_find_first(core, "files/location"))
    occ_df <- dt(lapply(xml_find_all(core, "field"), function(z) {
      as.list(xml_attrs(z))
    }))
  }

  multi <- xml_find_first(tmp, "//extension[contains(@rowType, \"Multimedia\")]")
  if (inherits(multi, "xml_missing")) {
    multi_file <- "multimedia"
    multi_df <- list()
  } else {
    multi_file <- xml_text(xml_find_first(multi, "files/location"))
    multi_df <- dt(lapply(xml_find_all(multi, "field"), function(z) {
      as.list(xml_attrs(z))
    }))
  }

  verb <- xml_find_first(tmp, "//extension[contains(@rowType, \"Occurrence\")]")
  if (inherits(verb, "xml_missing")) {
    verb_file <- "occurrence"
    verb_df <- list()
  } else {
    verb_file <- xml_text(xml_find_first(verb, "files/location"))
    verb_df <- dt(lapply(xml_find_all(verb, "field"), function(z) {
      as.list(xml_attrs(z))
    }))
  }

  Filter(function(z) length(z) != 0, stats::setNames(
    list(occ_df, multi_df, verb_df),
    c(occ_file, multi_file, verb_file)
  ))
}

# test if file contents is EML
is_eml <- function(x) any( grepl("eml:eml", readLines(x, n = 5)) )

# gives back file path
get_eml <- function(x) {
  tmp <- read_xml(grep("meta.xml", x, value = TRUE))
  ff <- xml_attr(tmp, "metadata")
  grep(ff, x, value = TRUE)
}

# try to read in EML metadata
try_eml <- function(w) EML::read_eml(get_eml(w))

#' @export
print.dwca_gbif <- function(x, ...){
  cat("<gbif dwca>", sep = "\n")
  cat(paste0("  Package ID: ", cmeta(x)), sep = "\n")
  cat(paste0("  No. data sources: ", length(x$dataset_meta)), sep = "\n")
  cat(paste0("  No. datasets: ", length(x$data)), sep = "\n")
  for (i in seq_along(x$data)) {
    if (attr(x, "read")) {
      cat(sprintf("  Dataset %s: [%s X %s]", names(x$data[i]),
                  NCOL(x$data[[i]]), NROW(x$data[[i]])), sep = "\n")
    } else {
      z <- sprintf("  Dataset %s: %s", names(x$data[i]), x$data[[i]])
      if (length(z) > 0) cat(z, sep = "\n")
    }
  }
}

cmeta <- function(y) {
  if ( !is.null(y$emlmeta) ) {
    y$emlmeta@packageId
  } else {
    NULL
  }
}

parse_dwca <- function(x){
  ff <- list.files(x, full.names = TRUE)
  list(xml_files = grep("\\.xml", ff, value = TRUE),
       txt_files = grep("\\.txt", ff, value = TRUE),
       datasets_meta = list.files(grep("dataset", ff, value = TRUE),
                                  full.names = TRUE),
       data_paths = data_paths(ff))
}

data_paths <- function(x){
  basedir <- dirname(grep("meta.xml", x, value = TRUE))
  meta <- read_xml(grep("meta.xml", x, value = TRUE))
  xml_ns_strip(meta)
  file.path(basedir, xml_text(xml_find_all(meta, "//files/location")))
}

read_data <- function(x, read){
  if ( read ) {
    datout <- list()
    for (i in seq_along(x)) {
      datout[[basename(x[[i]])]] <- try_read(x[[i]])
    }
    datout
  } else {
    x
  }
}

try_read <- function(z){
  res <- tryCatch(
    suppressWarnings(
      data.table::fread(z, stringsAsFactors = FALSE, data.table = FALSE,
                        sep = "\t", quote = "")
    ), error = function(e) e
  )
  if ( inherits(res, "simpleError") ) {
    data.frame(NULL, stringsAsFactors = FALSE)
  } else {
    res
  }
}

process <- function(x){
  switch(
    attr(x, "type"),
    dir = x,
    file = {
      dirpath <- sub("\\.zip", "", x[[1]])
      utils::unzip(x, exdir = dirpath)
      dirpath
    },
    url = dwca_cache_get(x)
  )
}

dwca_cache_get <- function(url) {
  sha <- digest::digest(url, algo = "sha1")
  key <- paste0(sha, ".zip")
  fpath <- file.path(finch_cache(), key)
  dirpath <- sub("\\.zip", "", fpath)
  if (file.exists(dirpath)) {
    message("File in cache")
    return(dirpath)
  } else {
    on.exit(unlink(fpath))
    dir.create(finch_cache(), showWarnings = FALSE, recursive = TRUE)
    utils::download.file(url = url, destfile = fpath, quiet = FALSE)
    utils::unzip(fpath, exdir = dirpath)
    return(dirpath)
  }
}
