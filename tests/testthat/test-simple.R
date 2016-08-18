context("simple")

test_that("SimpleDarwinRecordSet parsing works", {
  file1 <- system.file("examples", "example_simple.xml", package = "finch")
  a <- simple_read(file1)

  file2 <- system.file("examples", "example_simple_fossil.xml", package = "finch")
  b <- simple_read(file2)

  expect_equal(names(a), c('meta','dc','dwc'))
  expect_is(a, "dwc_simplerecordset")
  expect_type(a, "list")
  expect_is(a$meta, 'list')
  expect_is(a$meta$dwc, 'character')
  expect_is(a$dc, 'list')

  expect_equal(names(b), c('meta','dc','dwc'))
  expect_is(b, "dwc_simplerecordset")
  expect_type(b, "list")
  expect_is(b$meta, 'list')
  expect_is(b$meta$dwc, 'character')
  expect_is(b$dc, 'list')
})

test_that("DarwinRecordSet parsing works", {
  file1 <- system.file("examples", "example_classes_observation.xml", package = "finch")
  a <- simple_read(file1)

  expect_equal(names(a), c('meta','locations','chunks'))
  expect_is(a, "dwc_recordset")
  expect_type(a, "list")
  expect_is(a$meta, 'list')
  expect_is(a$meta$dwc, 'character')
  expect_is(a$locations, 'list')
  expect_is(a$chunks, 'list')
})

test_that("passing in inappropriate things fails correctly", {
  expect_error(simple_read(5345), "invalid 'file' argument")
  expect_error(simple_read("adfasdf"), "file does not exist")
})
