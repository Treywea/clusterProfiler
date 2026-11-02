## ##' plot method generics
## ##'
## ##'
## ##' @docType methods
## ##' @name plot
## ##' @rdname plot-methods
## ##' @title plot method
## ##' @param ... Additional argument list
## ##' @return plot
## ##' @importFrom stats4 plot
## ##' @export
## ##' @author Guangchuang Yu \url{https://yulab-smu.top}
## if ( !isGeneric("plot") )
## 	setGeneric("plot", function(x, ...) standardGeneric("plot"))


setGeneric("simplify", function(x, ...) standardGeneric("simplify"))

## interpret() and interpret_agent() are defined here once so that other packages can
## interpret their own classes by adding a method, e.g. in epiSeeker:
##   importFrom(clusterProfiler, interpret); setMethod("interpret", "csAnno", ...)
## A package that calls setGeneric("interpret") itself creates a second generic of the
## same name and masks this one. The enrichment implementation is the "ANY" method.

#' @rdname interpret
#' @importFrom methods setGeneric setMethod
#' @export
setGeneric("interpret", function(x, ...) standardGeneric("interpret"))

#' @rdname interpret_agent
#' @export
setGeneric("interpret_agent", function(x, ...) standardGeneric("interpret_agent"))



