library(testthat)

generic_input <- function() {
  data.frame(
    ID = c("GO:0006915", "GO:0008284"),
    Description = c("apoptotic process", "positive regulation of proliferation"),
    GeneRatio = c("10/100", "20/100"),
    p.adjust = c(0.01, 0.02),
    geneID = c("TP53/BAX", "MYC/CCND1/CDK4"),
    stringsAsFactors = FALSE
  )
}

test_that("interpret() and interpret_agent() are S4 generics whose ANY method is the enrichment code", {
  ns <- asNamespace("clusterProfiler")
  for (f in c("interpret", "interpret_agent")) {
    expect_true(methods::is(get(f, envir = ns), "standardGeneric"))
    expect_true(methods::existsMethod(f, "ANY", where = ns))
  }
})

test_that("the ANY method takes context by position and still requires x", {
  local_mocked_bindings(
    .interpret_run = function(x, context = NULL, ...) context,
    .package = "clusterProfiler"
  )
  expect_equal(clusterProfiler::interpret(generic_input(), "positional context"), "positional context")
  expect_error(clusterProfiler::interpret(), "required")
  expect_error(clusterProfiler::interpret_agent(), "required")
})

test_that("a method another package adds for its class is used for that class only", {
  env <- new.env()
  methods::setClass("cpToyRegions", representation(n = "numeric"), where = env)
  methods::setMethod(clusterProfiler::interpret, "cpToyRegions",
                     function(x, assay = NULL, ...) paste("regions", assay), where = env)
  on.exit({
    methods::removeMethod(clusterProfiler::interpret, "cpToyRegions", where = env)
    methods::removeClass("cpToyRegions", where = env)
  })

  expect_equal(clusterProfiler::interpret(methods::new("cpToyRegions", n = 1), assay = "ATAC"),
               "regions ATAC")
  ## an unsupported input names its class and the classes that do have a method
  expect_error(clusterProfiler::interpret(1:3), "Unsupported input type `integer`")
  expect_error(clusterProfiler::interpret(1:3), "also interpret: cpToyRegions")

  local_mocked_bindings(
    .interpret_run = function(x, ...) class(x)[1],
    .package = "clusterProfiler"
  )
  expect_equal(clusterProfiler::interpret(generic_input()), "data.frame")
})
