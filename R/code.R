#' Stuff
#'
#' @param xxx asdfadf
#' @examples \dontrun{
#'
#' }

foo <- function(x){
  print(x)
}

library("EML")

# read data
library("data.table")
library("dplyr")
eml_read("~/Downloads/0009933-141123120432318/dataset/38b4c89f-584c-41bb-bd8f-cd1def33e92f.xml")
dat <- fread("~/Downloads/0009933-141123120432318/occurrence.txt")
dat %>% tbl_df

# parse darwin core files
library("XML")
xml <- xmlParse("inst/examples/example_simple.xml")
xpathSApply(xml, "\\SimpleDarwinRecord")
#

XML::xmlSchemaValidate(xml, )
