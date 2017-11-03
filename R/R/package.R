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
#' @importFrom reticulate import iterate iter_next import_from_path py_iterator 
#' @importFrom reticulate py_get_attr py_list_attributes py_to_r
#' @importFrom graphics par plot points
"_PACKAGE"

# Main Construe module
CONSTRUE_MODULES <<- NULL

.onLoad <- function(libname, pkgname) {
  construe_python = Sys.getenv('CONSTRUE_PYTHON')
  if (construe_python != "") {
    Sys.setenv(RETICULATE_PYTHON = construe_python)
  }
  # TODO: setting warn to TRUE does not pass checks --as-cran
  if (!is_python_27(warn = TRUE) | !is_construe_installed(warn = TRUE)) {
    CONSTRUE_MODULES <<- NULL
  } else {
    #delay load construe
    CONSTRUE_MODULES <<- import_from_path('construe', get_construe_path(), delay_load = TRUE)
  }
}

get_construe_path = function() {
  file.path(find.package('construe'), '/inst/python')
}

