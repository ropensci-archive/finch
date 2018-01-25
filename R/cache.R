#' @title Caching
#'
#' @description Manage cached `finch` files with package \pkg{hoardr}
#'
#' @export
#' @name dwca_cache
#'
#' @details The dafault cache directory is
#' `paste0(rappdirs::user_cache_dir(), "/R/finch")`, but you can set
#' your own path using `cache_path_set()`
#'
#' `cache_delete` only accepts one file name, while
#' `cache_delete_all` doesn't accept any names, but deletes all files.
#' For deleting many specific files, use `cache_delete` in a [lapply()]
#' type call
#'
#' @section Useful user functions:
#'
#' - `dwca_cache$cache_path_get()` get cache path
#' - `dwca_cache$cache_path_set()` set cache path
#' - `dwca_cache$list()` returns a character vector of full
#'  path file names
#' - `dwca_cache$files()` returns file objects with metadata
#' - `dwca_cache$details()` returns files with details
#' - `dwca_cache$delete()` delete specific files
#' - `dwca_cache$delete_all()` delete all files, returns nothing
#'
#' @examples \dontrun{
#' dwca_cache
#'
#' # list files in cache
#' dwca_cache$list()
#'
#' # delete certain database files
#' # dwca_cache$delete("file path")
#' # dwca_cache$list()
#'
#' # delete all files in cache
#' # dwca_cache$delete_all()
#' # dwca_cache$list()
#'
#' # set a different cache path from the default
#' }
NULL
