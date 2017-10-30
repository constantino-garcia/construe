#' @importFrom dplyr filter
#' @importFrom magrittr %>%
#' @export
install_construe = function(url = 'https://api.github.com/repos/citiususc/construe/zipball',
                            dependencies = TRUE) {
  stopifnot(is_python_27(warn = TRUE))
  # Download the Python code to the inst folder, under the construe R package
  message('Downloading construe...')
  request = httr::GET(url)

  if (httr::status_code(request) >= 400) {
    # TODO: improve error message
    stop("Error downloading Construe source code")
  }
  
  tmp = tempfile(fileext = '.zip')
  writeBin(httr::content(request, "raw"), tmp)
  # 
  message('Unzipping construe...')
  # extract only files under the construe folder in the root directory
  files = unzip(tmp, list=TRUE)
  root = files[1, "Name"]
  files = files %>% dplyr::filter(grepl(paste0(root, 'construe'), Name)) %>% .$Name
  
  packageFolder = find.package('construe')
  extractTo = file.path(packageFolder, 'inst')
  unzip(tmp, files = files, exdir = extractTo)
  
  # Rename the extracted directory so that the final installation folder is
  # <pkg>/inst/python
  installationDirectory = file.path(extractTo, 'python')
  if (dir.exists(installationDirectory)) {
    unlink(installationDirectory, recursive = TRUE, force = TRUE)
  }
  file.rename(file.path(extractTo, root), installationDirectory)
  # check that the installation directory matches the expected location of construe
  stopifnot(normalizePath(installationDirectory) == normalizePath(get_construe_path()))
  
  install_dependencies()
  
  message('Installation complete. Restart the R console to make changes effective')
  # TODO: Not working. check why
  # message('Try:\n > detach("package:construe", unload=TRUE)\n > library("construe")')
}

#' @export
install_dependencies = function() {
  # TODO: RETRIEVE DEPENDENCIES DYNAMICALLY
  dependencies = c('sortedcontainers', 'numpy', 'scipy', 'scikit-learn', 'PyWavelets')
  python = reticulate::py_config()$python
  # If python binary has some version name of it, we extract it
  # e.g., from 'python3' -> '3'
  # some is the start position after the 6 letters of 'python'
  pythonVersionName = substr(basename(python), 7, nchar(basename(python)))
  
  # if Windows, we only perform the installation when conda is available
  if (identical(.Platform$OS.type, "windows")) {
    # TODO: check
    pip = file.path(dirname(python), "Scripts", "pip.exe")
  } else {
    pip = file.path(dirname(python), paste0("pip", pythonVersionName))
  }
  
  # execute the installation
  result = system2(pip, c("install", "--upgrade --ignore-installed",
                           paste(shQuote(dependencies), collapse = " ")))
  if (result != 0L) {
    stop("Error ", result, " occurred installing construe dependencies.", call. = FALSE)
  }
}
