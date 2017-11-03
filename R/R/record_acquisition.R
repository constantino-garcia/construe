#' Acquisition system
#' @description Interface to control the acquisition system to work with signal records simulating the real-time input.
#' @describeIn record_acquisition Sets the record used for input and the initial evidence.
#' @param record Name/Path of the MIT-BIH record containing the input signal.
#' @param annotator It can be a string with the name of the annotator, or a list of
#' annotations with the initial evidence to be interpreted.
#' @param physical_units Flag to set whether the signal is in digital or physical units.
#' @export
set_record = function(record, annotator = NULL, physical_units = FALSE) {
  CONSTRUE_MODULES$acquisition$record_acquisition$set_record(record, annotator, physical_units)
}

#' @describeIn record_acquisition Sets an offset in the record from where the
#' acquisition should start.
#' @param offset The offset where the acquisition should start.
#' @export
set_offset = function(offset) {
  CONSTRUE_MODULES$acquisition$record_acquisition$set_offset(as.integer(offset))
}

#' @describeIn record_acquisition Sets the duration of the record/fragment to 
#' be interpreted.
#' @param duration The duration of the record/fragment. It has to be multiple of
#' 256, and the maximum value currently allowed is 23040.
#' @export
set_duration = function(duration) {
  kMaxValue = 23040
  if (duration %% 256 != 0) {
    stop("'duration' has to be multiple of 256")
  }
  if (duration > kMaxValue) {
    warning(paste0("The maximum value of 'duration' is ", kMaxValue,
                   ". Clipping value")
    )
    duration = kMaxValue
  }
  CONSTRUE_MODULES$acquisition$record_acquisition$set_duration(as.integer(duration))
}

#' @describeIn record_acquisition Sets the time factor to control the input speed.
#' @param tfactor Time factor controlling the input speed.
#' @export
set_tfactor = function(tfactor) {
  CONSTRUE_MODULES$acquisition$record_acquisition$set_tfactor(as.integer(tfactor))
}

#' @describeIn record_acquisition Obtains the temporal factor controlling the current input speed.
#' @export
get_tfactor = function() {
  CONSTRUE_MODULES$acquisition$record_acquisition$get_tfactor()
}

#' @describeIn record_acquisition Resets the acquisition system.
#' @export
reset_acquisition = function() {
  CONSTRUE_MODULES$acquisition$record_acquisition$reset()
}

#' @describeIn record_acquisition Starts the acquisition of signal and evidence.
#' @export
start_acquisition = function() {
  CONSTRUE_MODULES$acquisition$record_acquisition$start()
}

#' @describeIn record_acquisition Stops the acquisition of signal and evidence.
#' @export
stop_acquisition = function() {
  CONSTRUE_MODULES$acquisition$record_acquisition$stop()
}

#' @describeIn record_acquisition Obtains the time point, in signal samples, where the
#'  acquisition process is.
#' @export
get_more_evidence = function() {
  CONSTRUE_MODULES$acquisition$record_acquisition$get_more_evidence()
}

#' @describeIn record_acquisition Obtains the time point, in signal samples, where the 
#' acquisition process is.
#' @export
get_acquisition_point = function() {
  CONSTRUE_MODULES$acquisition$record_acquisition$get_acquisition_point()
}
 
#' @describeIn record_acquisition Obtains the length of the record.
#' @export
get_record_length = function() {
  CONSTRUE_MODULES$acquisition$record_acquisition$get_record_length()
}
 
#' @describeIn record_acquisition Obtains the name of the input reecord.
#' @export
get_record_name = function() {
  CONSTRUE_MODULES$acquisition$record_acquisition$get_record_name()
}
