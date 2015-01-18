pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}

# validate_schema <- function(x){
#   XML::xmlSchemaValidate(xml, )
# }
