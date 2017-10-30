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
