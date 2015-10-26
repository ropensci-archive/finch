#' Parse Darwin Core Archive
#'
#' @export
#'
#' @param input Path to local zip file, directory, or a url.
#' @param read (logical)
#' @param ... Further args passed on to \code{\link[data.table]{fread}}
#' @details
#' Note that sometimes file reads fail. We use \code{\link[data.table]{fread}}
#' internally, which is very fast, but can fail sometimes. If so, try reading in the
#' data manually.
#' @examples \dontrun{
#' dir <- "~/Downloads/0009933-141123120432318/"
#'
#' # Don't read data in
#' x <- dwca(dir, read=FALSE)
#' x
#' x$files
#' x$highmeta
#' x$dataset_meta[[1]]
#' x$data
#'
#' # Read data
#' x <- dwca(dir, read=TRUE)
#' x
#' head( x$data[[1]] )
#'
#' out <- dwca("~/Downloads/0000143-150116162929234/")
#' out
#' dwca("~/Downloads/0000143-150116162929234/", TRUE)
#' dwca("~/Downloads/0000154-150116162929234/", TRUE)
#'
#' # Can pass in a zip file
#' out <- dwca("~/Downloads/0000154-150116162929234.zip")
#' out <- dwca("~/Downloads/DwCArchive_Cicadellinae.zip")
#' out$files
#' out$highmeta
#' out$emlmeta
#' out$dataset_meta
#'
#' # Can pass in zip file as a url
#' x <- "http://ecat-dev.gbif.org/repository/vernaculars/vernacular_registry_dwca_3.zip"
#' out <- dwca(x)
#'
#' # This one fails on file read
#' out <- dwca("~/Downloads/0000153-150116162929234/", TRUE)
#' }

dwca <- function(input, read=FALSE, ...){
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
  dataset_meta <- lapply(files$datasets_meta, EML::eml_read)
  # get data
  datout <- read_data(files$data_paths, read)

  structure(list(files=files,
                 highmeta = highmeta,
                 emlmeta = emlmeta,
                 dataset_meta = dataset_meta,
                 data = datout), class="dwca_gbif", read=read)
}

try_meta <- function(x) {
  tmp <- xmlParse(grep("meta.xml", x, value = TRUE))
  childs <- xmlChildren(xmlChildren(tmp)$archive)
  out <- list()
  for(i in seq_along(childs)){
    res <- xmlChildren(childs[[i]])
    loc <- xmlValue(res$files)
    dat <- unname(lapply(res[ names(res) == "field" ], function(x) data.frame(as.list(xmlAttrs(x)))))
    out[[loc]] <- do.call("rbind.fill", dat)
  }
  out
}

is_eml <- function(x) any( grepl("eml:eml", readLines(x, n = 5)) )

get_eml <- function(x){
  tmp <- xmlParse(grep("meta.xml", x, value = TRUE))
  ff <- xmlToList(xmlChildren(tmp)$archive)$.attrs[["metadata"]]
  grep(ff, x, value = TRUE)
}

try_eml <- function(x) EML::eml_read(get_eml(x))
# {
#   y <- sapply(x, is_eml)
#   if( any(y) )
#     EML::eml_read(x[y])
#   else
#     NULL
# }

#' @export
print.dwca_gbif <- function(x, ...){
  cat("<gbif dwca>", sep = "\n")
  cat(paste0("  Package ID: ", cmeta(x)), sep = "\n")
  cat(paste0("  No. data sources: ", length(x$dataset_meta)), sep = "\n")
  cat(paste0("  No. datasets: ", length(x$data)), sep = "\n")
  for(i in seq_along(x$data)){
    if(attr(x, "read"))
      cat(sprintf("  Dataset %s: [%s X %s]", names(x$data[i]), NCOL(x$data[[i]]), NROW(x$data[[i]])), sep = "\n")
    else
      cat(sprintf("  Dataset %s: %s", names(x$data[i]), x$data[[i]]), sep = "\n")
  }
}

cmeta <- function(y){
  if( !is.null(y$emlmeta) )
    y$emlmeta@packageId
  else
    NULL
}

parse_dwca <- function(x){
  ff <- list.files(x, full.names = TRUE)
  list(xml_files = grep("\\.xml", ff, value = TRUE),
       txt_files = grep("\\.txt", ff, value = TRUE),
       datasets_meta = list.files(grep("dataset", ff, value = TRUE), full.names = TRUE),
       data_paths = data_paths(ff))
}

data_paths <- function(x){
  basedir <- dirname(grep("meta.xml", x, value = TRUE))
  meta <- xmlParse(grep("meta.xml", x, value = TRUE))
  children <- xmlChildren(xmlChildren(meta)$archive)
  lapply(children, function(x) file.path(basedir, xmlToList(x)$files$location))
}

read_data <- function(x, read){
  if( read ){
    datout <- list()
    for(i in seq_along(x)){
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
      data.table::fread(z, stringsAsFactors = FALSE, data.table = FALSE)
    ), error = function(e) e
  )
  if( is(res, "simpleError") )
    data.frame(NULL, stringsAsFactors = FALSE)
  else
    res
}

process <- function(x){
  switch(attr(x, "type"),
         dir = x,
         file = {
           dirpath <- sub("\\.zip", "", x[[1]])
           unzip(x, exdir = dirpath)
           dirpath
         },
         url = {
           writepath <- file.path(Sys.getenv("HOME"), basename(x))
           download.file(url = x, destfile = writepath)
           dirpath <- sub("\\.zip", "", writepath)
           unzip(writepath, exdir = dirpath)
           dirpath
         }
  )
}
