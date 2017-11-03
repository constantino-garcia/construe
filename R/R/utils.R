is_python_27 = function(warn = FALSE) {
  isPython27 = reticulate::py_config()$version <= "2.7" 
  if (!isPython27 && warn) {
    warning(paste(
      'Python 3 detected. For the moment, construe only works with python 2.7.',
      'Use the CONSTRUE_PYTHON env variable or see',
      '<https://rstudio.github.io/reticulate/articles/versions.html>',
      'to specify a valid python 2.7 binary.'
    ))
  }
  isPython27 
}

# @param fullClassName A string representing the complete class name to be loaded
# (with the modules). E.g., fullClassName = 'construe.model.observable.Observable'. 
# @returns The python class 
#' @importFrom utils tail
get_python_class = function(fullClassName) {
  modules = unlist(strsplit(fullClassName, '[.]'))
  # remove the 'construe' module, since it is where CONSTRUE_MODULES points to,
  # and the className
  className = tail(modules, 1)
  modules = modules[-c(1, length(modules))]
  tryCatch(
    CONSTRUE_MODULES[[paste(collapse = '.', modules)]][[className]],
    # Rewrite the error to make it more readable
    error = function(e) {
      stop(paste('Module', fullClassName, 'not found'), call. = FALSE)
    }
  )
}  

#' @describeIn construe_utils Get time using python module time instead of 
#' Sys.time()
#' @export
get_time = function() {
  time = import("time")
  time$time()
}
