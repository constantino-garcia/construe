#' R interface to Construe
#'
#' Construe is a knowledge-based abductive framework for time series interpretation.
#' It provides a knowledge representation model and a set of algorithms for the
#' interpretation of temporal information, implementing a hypothesize-and-test
#' cycle guided by an attentional mechanism. 
#' 
#' This package provides an R interface to the Construe framework for the interpretation of
#' electrocardiogram (ECG) signals in terms of the basic waveforms (P, QRS, T) to complex rhythm
#' patterns (Atrial fibrillation, Bigeminy, Trigeminy, Ventricular flutter/fibrillation, etc.).
#' 
#' See the Construe website at <https://github.com/citiususc/construe/> for complete documentation.
#'
#' @import methods
#' @import R6
#' @importFrom reticulate import dict iterate import_from_path py_iterator py_call py_capture_output py_get_attr py_has_attr py_is_null_xptr py_to_r r_to_py tuple
#' @importFrom graphics par plot points
"_PACKAGE"

# Main Construe module
construe <<- NULL

.onLoad <- function(libname, pkgname) {
  construe_python = Sys.getenv('CONSTRUE_PYTHON')
  if (construe_python != "") {
    Sys.setenv(RETICULATE_PYTHON = construe_python)
  }
  
  if (!is_python_27(warn = TRUE) | !is_construe_installed(warn = TRUE)) {
    construe <<- NULL
  } else {
    #delay load construe
    construe <<- import_from_path('construe', get_construe_path(), delay_load = TRUE)
  }
  
}

get_construe_path = function() {
  file.path(find.package('construe'), '/inst/python')
}

is_construe_installed = function(warn = FALSE) {
  # On error, set path to NULL
  construePath = tryCatch(get_construe_path(), error=function(e) NULL)
  isInstalled = !is.null(construePath) && file.exists(file.path(construePath, 'construe'))
  if (!isInstalled && warn) {
    warning(paste0(
      "Could not find a valid Construe installation.",
      " Use install_construe().")
    )
  }
  isInstalled
}
