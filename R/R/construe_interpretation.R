#' Construe
#' @description A class that implements the Construe algorithm allowing fine-grained
#' control of the steps of the algorithm.
#' @param root_node An object of class \emph{construe_interpretation} (see
#'  \link{ConstrueInterpretation}.)
#' that determines the root node for the exploration of hypothesis.
#' @param k Integer representing the width of the search in the exploration. 
#' @export
Construe = function(root_node, k) {
  if (!inherits(root_node, "construe.model.interpretation.Interpretation")) {
    stop("'root_node' should be a 'ConstrueInterpretation' object. See ?ConstrueInterpretation.")
  }
  if (k < 1) {
    stop('k should be >= 1.')
  }
  CONSTRUE_MODULES$inference$searching$Construe(root_node, as.integer(k))
}

#' Construe interpretation
#' @description Creates an object that represents the interpretation entity, which is a consistent
#' group of abstraction hypotheses combined by the knowledge expressed in abstraction patterns.
#' It is the basic entity in our search process, and the result of an interpretation process.
#' @export
ConstrueInterpretation = function() {
  CONSTRUE_MODULES$model$interpretation$Interpretation(NULL)
}



