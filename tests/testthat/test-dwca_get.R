context("dwca_get")

# set up a temporary directory for tests
invisible(dwca_cache$cache_path_set(path = "finch", type = "tempdir"))
 

test_that("dwca_get - works with a directory - read=FALSE", {
  dir <- system.file("examples", "0000154-150116162929234", package = "finch")

  aa <- dwca_read(dir, read = FALSE)

  expect_named(aa, c('files','highmeta','emlmeta','dataset_meta','data'))
  expect_is(aa, "dwca_gbif")
  expect_type(aa, "list")
  expect_is(aa$files, 'list')
  expect_is(aa$highmeta, 'list')
  expect_is(aa$highmeta$occurrence.txt, 'data.frame')
  expect_is(aa$emlmeta, 'emld')
  expect_is(aa$data, 'character')
})

test_that("dwca_get - works with a zip file - read=FALSE", {
  zip <- system.file("examples", "0000154-150116162929234.zip", package = "finch")

  aa <- suppressMessages(dwca_read(zip, read = FALSE))

  expect_named(aa, c('files','highmeta','emlmeta','dataset_meta','data'))
  expect_is(aa, "dwca_gbif")
  expect_type(aa, "list")
  expect_is(aa$files, 'list')
  expect_is(aa$highmeta, 'list')
  expect_is(aa$highmeta$occurrence.txt, 'data.frame')
  expect_is(aa$emlmeta, 'emld')
  expect_is(aa$data, 'character')
})

test_that("dwca_get - works with a url - read=FALSE", {
  skip_on_cran()
  if (!ping_internet()) skip("No internet connection")

  url <- "http://ipt.jbrj.gov.br/jbrj/archive.do?r=redlist_2013_taxons&v=3.12"

  aa <- suppressMessages(dwca_read(url, read = FALSE))

  expect_named(aa, c('files','highmeta','emlmeta','dataset_meta','data'))
  expect_is(aa, "dwca_gbif")
  expect_type(aa, "list")
  expect_is(aa$files, 'list')
  expect_is(aa$highmeta, 'list')
  expect_is(aa$highmeta$taxon.txt, 'data.frame')
  expect_is(aa$emlmeta, 'emld')
  expect_is(aa$data, 'character')
  expect_null(names(aa$data))

  # delete cache
  dwca_cache$delete_all()
})

test_that("dwca_get - works with a url - read=TRUE", {
  skip_on_cran()
  if (!ping_internet()) skip("No internet connection")

  url <- "http://ipt.jbrj.gov.br/jbrj/archive.do?r=redlist_2013_taxons&v=3.12"

  aa <- suppressMessages(dwca_read(url, read = TRUE))

  expect_named(aa, c('files','highmeta','emlmeta','dataset_meta','data'))
  expect_is(aa, "dwca_gbif")
  expect_type(aa, "list")
  expect_is(aa$data, 'list')
  expect_is(aa$data$taxon.txt, 'data.frame')
  expect_is(aa$data$distribution.txt, 'data.frame')

  # delete cache
  dwca_cache$delete_all()
})
