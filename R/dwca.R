#' Parse Darwin Core Archive
#'
#' @export
#' @import EML data.table
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
  # get datasets metadata
  dataset_meta <- lapply(files$datasets_meta, EML::eml_read)
  # high level metadata
  highmeta <- try_eml(files$xml_files)
  # highmeta <- EML::eml_read(grep("metadata.xml", files$xml_files, value = TRUE))
  # get data
  datout <- read_data(files$data_paths, read)

  structure(list(files=files,
                 highmeta = highmeta,
                 dataset_meta=dataset_meta,
                 data = datout), class="dwca_gbif", read=read)
}

try_eml <- function(x){
  y <- grep("metadata.xml", x, value = TRUE)
  if( length(y) == 0 )
    NULL
  else
    EML::eml_read(y)
}

print.dwca_gbif <- function(x){
  cat("<gbif dwca>", sep = "\n")
  cat(paste0("  Package ID: ", x$highmeta@packageId), sep = "\n")
  cat(paste0("  No. data sources: ", length(x$dataset_meta)), sep = "\n")
  cat(paste0("  No. datasets: ", length(x$data)), sep = "\n")
  for(i in seq_along(x$data)){
    if(attr(x, "read"))
      cat(sprintf("  Dataset %s: [%s X %s]", names(x$data[i]), NCOL(x$data[[i]]), NROW(x$data[[i]])), sep = "\n")
    else
      cat(sprintf("  Dataset %s: %s", names(x$data[i]), x$data[[i]]), sep = "\n")
  }
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
      datout[[basename(x[[i]])]] <- fread(x[[i]], stringsAsFactors = FALSE, data.table = FALSE)
    }
    datout
  } else {
    x
  }
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
