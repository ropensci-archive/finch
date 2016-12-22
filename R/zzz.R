pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}

fcmp <- function(z) Filter(Negate(is.null), z)

checkforpkg <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    stop("Please install ", x, call. = FALSE)
  } else {
    invisible(TRUE)
  }
}

dt <- function(x) {
  (data.table::setDF(data.table::rbindlist(x, use.names = TRUE, fill = TRUE)))
}
