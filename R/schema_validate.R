#' Validate a Darwin Core Archive file using the DCA schema
#'
#' @export
#' @param file A file path
#' @examples \dontrun{
#' file <- system.file("examples", "example_simple.xml", package = "finch")
#' file <- system.file("examples", "example_simple_fossil.xml", package = "finch")
#' file <- system.file("examples", "example_classes_observation.xml", package = "finch")
#' schema_validate(file)
#' }
schema_validate <- function(file) {
  schema <- system.file("dca_schema.xml", package = "finch")
  sch_parsed <- XML::xmlSchemaParse(schema)
  XML::xmlSchemaValidate(sch_parsed, xmlParse(file))
}
