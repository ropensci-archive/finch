ping_internet <- function() {
  w <- url('https://httpbin.org/get')
  res <- tryCatch(suppressWarnings(readLines(w)), error = function(e) e)
  on.exit(close(w))
  !inherits(res, "error")
}
