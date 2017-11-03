#' Observations buffer
#' @description Global dynamic observations buffer for the interpretation
#' process, where all base evidence is published and made available to 
#' all interpretations.
#' @describeIn observations_buffer Resets the observations
#' buffer.
#' @export
reset = function() {
  CONSTRUE_MODULES$acquisition$obs_buffer$reset()
}

#' @describeIn observations_buffer Adds a new piece of evidence to this global 
#' observations buffer.
#' This observation must have a temporal location after any already published 
#' observation. 
#' @param observation An instance of \emph{Observable} or one of its subclasses.
#' See \link{Observable}.
#' @export
publish_observation = function(observation) {
  CONSTRUE_MODULES$acquisition$obs_buffer$publish_observation(observation)
} 

#' @describeIn observations_buffer Obtains a list of observations matching the 
#' search criteria, ordered by the earliest time of the observation.
#' @param clazz Only instances of the \emph{clazz} class (or any subclass) are
#' returned. The R function name (without parentheses and quotes) should 
#' be used to specify the desired class. E.g., \emph{clazz = RR}.
#' @param start Only observations whose \emph{earlystart} attribute is after or
#' equal this parameter are returned. 
#' @param end Only observations whose \emph{lateend} attribute is lower or equal
#' this parameter are returned. 
#' @param filt A boolean function that accepts an observation as a parameter 
#' acting as a filter. Only the observations satisfying this filter are returned.
#' @param reverse Boolean parameter. If TRUE, observations are returned in 
#' reversed order, from last to first. 
#' @return A wrapper around a python iterator. To iterate the observations, the
#' \code{\link[reticulate]{iterate}} or \code{\link[reticulate]{iter_next}} can
#' be used.
#' @export
get_observations = function(clazz = Observable, start = 0, end = Inf, 
                            filt = function(obs) TRUE, reverse=FALSE) {
  if (!'python_class' %in% names(attributes(clazz))) {
    stop(
      paste(
      "Invalid 'clazz' argument. The R function name (without parentheses and quotes) should",
      "be used to specify the desired class. E.g., clazz = RR."
      )
    )
  }
  clazz = get_python_class(attr(clazz, 'python_class'))
  CONSTRUE_MODULES$acquisition$obs_buffer$get_observations(
    clazz, start, end, filt, reverse
  )
} 

#' @describeIn observations_buffer Checks if an observation is in the 
#' observations buffer.
#' @inheritParams publish_observation
#' @export
contains_observation = function(observation) {
  CONSTRUE_MODULES$acquisition$obs_buffer$contains_observation()
} 

# private function
# get valid values of status, e.g., "ACQUIRING" or "STOPPED".
get_valid_statuses = function() {
  attrs = py_list_attributes(CONSTRUE_MODULES$acquisition$obs_buffer$Status) %>% 
    grep(pattern = "^[^_]", value = TRUE)
  sapply(attrs, 
         function(attr) py_to_r(
           py_get_attr(CONSTRUE_MODULES$acquisition$obs_buffer$Status,
                       attr)
         )
  )
}

#' @describeIn observations_buffer Obtains the status of the observations buffer.
#' @export
get_status = function() {
  validStatuses = get_valid_statuses()
  # get the name of the status and return it
  names(
    which(CONSTRUE_MODULES$acquisition$obs_buffer$get_status() == validStatuses)
  )
} 

#' @describeIn observations_buffer Changes the status of the observations buffer.
#' @param status A status among 'ACQUIRING' or 'STOPPED'.
#' @export
set_status = function(status) {
  validStatuses = get_valid_statuses()
  if (!(status %in% names(validStatuses))) {
    stop(
      paste0(
        'Invalid status. It should be one of: ', 
        paste(collapse = ', ', names(validStatuses)),
        '.'
      )
    )
  } else {
    CONSTRUE_MODULES$acquisition$obs_buffer$set_status(validStatuses[[status]])
  }
} 

# TODO: we not provide an interface for nobs_before and find_overlapping
# since they seem to be not necessary. Check this assumption
