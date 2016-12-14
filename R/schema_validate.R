#' Validate a Darwin Core Archive file using the DCA schema
#'
#' @param file (character) A file path. Must be a Darwin Core Archive file
#' @keywords internal
#' @examples \dontrun{
#' file <- system.file("examples", "example_simple.xml", package = "finch")
#' file <- system.file("examples", "example_simple_fossil.xml",
#'   package = "finch")
#' file <- system.file("examples", "example_classes_observation.xml",
#'   package = "finch")
#' schema_validate(file)
#'
#' x <- system.file("examples", "example_bad1.xml", package = "finch")
#' # schema_validate(x)
#'
#' schema_path <- system.file("schemas/tdwg_dwcterms.xsd", package = "finch")
#'
#' # simple dwc file
#' file_path <- system.file("examples/example_simple.xml", package = "finch")
#' schema_path <- system.file("schemas/tdwg_dwc_simple.xsd", package = "finch")
#' schema_validate(file, schema_path)
#'
#' # classes dwc file
#' file_path <- system.file("examples", "example_classes_specimen.xml", package = "finch")
#' schema_path <- system.file("schemas/tdwg_dwc_class_terms.xsd", package = "finch")
#' schema_validate(file, schema_path)
#' }
schema_validate <- function(file_path, schema_path) {
  #schema <- system.file("dca_schema.xml", package = "finch")
  #schema_path <- system.file("schemas/tdwg_dwcterms.xsd", package = "finch")
  xml <- xml2::read_xml(file_path)
  schema <- xml2::read_xml(schema_path)
  xml2::xml_validate(xml, schema)

  # sch_parsed <- XML::xmlParse(schema, isSchema = TRUE, xinclude = TRUE,
  #                             asText = FALSE)
  # XML::xmlSchemaValidate(sch_parsed, XML::xmlParse(file))
}
