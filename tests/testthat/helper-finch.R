ping_internet <- function() {
  res <- tryCatch(
    suppressWarnings(download.file("httpbin.org", "asdf", quiet = TRUE)),
    error = function(e) e)
  !inherits(res, "error")
}
