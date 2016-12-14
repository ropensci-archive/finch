#' Manage cached files
#'
#' @export
#' @name dwca_cache
#' @param files (character) one or more complete file names
#' @param force (logical) Should files be force deleted? Default: \code{TRUE}
#'
#' @details \code{cache_delete} only accepts 1 file name, while
#' \code{cache_delete_all} doesn't accept any names, but deletes all files.
#' For deleting many specific files, use \code{cache_delete} in a
#' \code{\link{lapply}} type call
#'
#' @details We cache using \code{\link[rappdirs]{user_cache_dir}}, find your
#' cache folder by executing \code{rappdirs::user_cache_dir("finch-cache")}
#'
#' @section Functions:
#' \itemize{
#'  \item \code{dwca_cache_list()} returns a character vector of full path
#'  file names
#'  \item \code{dwca_cache_delete()} deletes one or more files, returns nothing
#'  \item \code{dwca_cache_delete_all()} delete all files, returns nothing
#'  \item \code{dwca_cache_details()} prints file name and file size for
#'  each file, supply with one or more files, or no files (and get details
#'  for all available)
#' }
#'
#' @examples \dontrun{
#' # list files in cache
#' dwca_cache_list()
#'
#' # List info for single files
#' dwca_cache_details(files = dwca_cache_list()[1])
#' dwca_cache_details(files = dwca_cache_list()[2])
#'
#' # List info for all files
#' dwca_cache_details()
#'
#' # delete files by name in cache
#' # dwca_cache_delete(files = dwca_cache_list()[1])
#'
#' # delete all files in cache
#' # dwca_cache_delete_all()
#' }

#' @export
#' @rdname dwca_cache
dwca_cache_list <- function() {
  list.files(finch_cache(), recursive = FALSE, full.names = TRUE)
}

#' @export
#' @rdname dwca_cache
dwca_cache_delete <- function(files, force = TRUE) {
  if (!all(file.exists(files))) {
    stop("These files don't exist or can't be found: \n",
         strwrap(files[!file.exists(files)], indent = 5), call. = FALSE)
  }
  unlink(files, force = force, recursive = TRUE)
}

#' @export
#' @rdname dwca_cache
dwca_cache_delete_all <- function(force = TRUE) {
  files <- list.files(finch_cache(), full.names = TRUE, recursive = FALSE)
  unlink(files, force = force, recursive = TRUE)
}

#' @export
#' @rdname dwca_cache
dwca_cache_details <- function(files = NULL) {
  if (is.null(files)) {
    files <- list.files(finch_cache(), full.names = TRUE, recursive = FALSE)
    structure(lapply(files, file_info_), class = "dwca_cache_info")
  } else {
    structure(lapply(files, file_info_), class = "dwca_cache_info")
  }
}

file_info_ <- function(x) {
  fs <- file.size(x)
  list(file = x,
       type = "dir",
       size = if (!is.na(fs)) getsize(fs) else NA
  )
}

getsize <- function(x) {
  round(x/10 ^ 6, 5)
}

#' @export
print.dwca_cache_info <- function(x, ...) {
  cat("<dwca cached files>", sep = "\n")
  cat(sprintf("  directory: %s\n", finch_cache()), sep = "\n")
  for (i in seq_along(x)) {
    cat(paste0("  file: ", sub(finch_cache(), "", x[[i]]$file)), sep = "\n")
    cat(paste0("  size: ", x[[i]]$size, " mb"), sep = "\n")
    cat("\n")
  }
}

finch_cache <- function() rappdirs::user_cache_dir("finch-cache")
