#' Construe utils
#' @describeIn construe_utils Obtains the milliseconds corresponding to a number
#' of signal samples.
#' @param samples Number of samples.
#' @export 
sp2ms = samples2msec = function(samples) {
  CONSTRUE_MODULES$utils$units_helper$samples2msec(samples)
}


#' @describeIn construe_utils Obtains the number of samples corresponding to a
#' milliseconds timespan.
#' @param msec Time in milliseconds.
#' @export
ms2sp = msec2samples = function(msec) {
  CONSTRUE_MODULES$utils$units_helper$msec2samples(msec)
}


# @export
# get_leads = function(recordPath) {
#   CONSTRUE_MODULES$utils$MIT$get_leads(path.expand(recordPath))
# }
