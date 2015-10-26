context("simple")

file1 <- system.file("examples", "example_simple.xml", package = "finch")
a <- simple_read(file1)

file2 <- system.file("examples", "example_simple_fossil.xml", package = "finch")
b <- simple_read(file2)

# darwin record set...
# file3 <- system.file("examples", "example_classes_specimen.xml", package = "finch")
# c <- simple(file3)

test_that("basic simple parsing works", {
  expect_equal(names(a), c('meta','dc','dwc'))
  expect_is(a, "dwc_simple")
  expect_equal(typeof(a), "list")
  expect_is(a$meta, 'list')
  expect_match(a$meta[[1]], 'simpledarwincore')
  expect_is(a$meta$dwc, 'character')
  expect_is(a$dc, 'list')

  expect_equal(names(b), c('meta','dc','dwc'))
  expect_is(b, "dwc_simple")
  expect_equal(typeof(b), "list")
  expect_is(b$meta, 'list')
  expect_match(b$meta[[1]], 'simpledarwincore')
  expect_is(b$meta$dwc, 'character')
  expect_is(b$dc, 'list')
})

test_that("passing in inaappropriate things fails correctly", {
  expect_error(simple_read(5345), "invalid 'file' argument")
  expect_error(simple_read("adfasdf"), "That file does not exist")
})
