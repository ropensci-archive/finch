#' Validate a Darwin Core Archive file using the DCA schema
#'
#' @param file (character) A file path. Must be a Darwin Core Archive file
#' @keywords internal
#' @examples \dontrun{
#' file <- system.file("examples", "example_simple.xml", package = "finch")
#' file <- system.file("examples", "example_simple_fossil.xml", package = "finch")
#' file <- system.file("examples", "example_classes_observation.xml", package = "finch")
#' schema_validate(file)
#'
#' x <- system.file("examples", "example_bad1.xml", package = "finch")
#' schema_validate(x)
#' }
schema_validate <- function(file) {
  schema <- system.file("dca_schema.xml", package = "finch")
  sch_parsed <- XML::xmlParse(schema, isSchema = TRUE, xinclude = TRUE, asText = FALSE)
  XML::xmlSchemaValidate(sch_parsed, XML::xmlParse(file))
}
