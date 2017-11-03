library('construe')
stopifnot(is_construe_installed(TRUE))

# change the path while executing the script
currentPath = force(getwd())
setwd(dirname(system.file('extdata', 'fig10.qrs', package = 'construe')))

# Searching settings ------------------------------------------------------
TFACTOR = 5.0
KFACTOR = 12
MIN_DELAY = 1750
MAX_DELAY = as.integer(ms2sp(20000) * TFACTOR)
CONSTRUE_MODULES$inference$searching$reasoning$SAVE_TREE = TRUE
CONSTRUE_MODULES$inference$searching$reasoning$MERGE_STRATEGY = FALSE

#Input system configuration
reset()
set_record('fig10', 'qrs')
set_offset(0)
set_duration(3840)
set_tfactor(TFACTOR)
start_acquisition()
message('Preloading buffer...')
Sys.sleep(sp2ms(MIN_DELAY) / (1000.0 * TFACTOR))
#Load the initial evidence
get_more_evidence()

#Trivial interpretation
interp = ConstrueInterpretation()
#The focus is initially set in the first observation
library('reticulate')
next_observation = iter_next(get_observations())
interp$focus$push(next_observation, NULL)

# Construe searching ------------------------------------------------------
message('Starting interpretation')
t0 = get_time()
cntr = Construe(interp, KFACTOR)
ltime = c(cntr$last_time, t0)
#Main loop
while (is.null(cntr$best)) {
  get_more_evidence()
  acq_time = get_acquisition_point()
  #HINT debug code
  fstr = 'Int: %.5f'
  for (i in seq_len(as.integer(sp2ms(acq_time - cntr$last_time) / 1000.0))) {
    fstr = paste0(fstr, '-')
  }
  fstr = paste0(fstr, ' Acq: %s')
  if (interp$counter > 100) {
    message(sprintf(fstr, as.integer(cntr$last_time), acq_time))
  }
  #End of debug code
  filt = ifelse(get_status() == 'ACQUIRING', 
                function(n) as.integer(acq_time + n$h$time) >= MIN_DELAY,
                function(n) TRUE
  )
  cntr$step(filt)
  if (cntr$last_time > ltime[1]) {
    ltime = c(cntr$last_time, get_time())
  }
  #If the distance between acquisition time and interpretation time is
  #excessive, the search tree is pruned.
  if (ms2sp((get_time() - ltime[[2]]) * 1000.0) * TFACTOR > MAX_DELAY) {
    message('Pruning search')
    cntr$prune()
  }
}

print(paste('Finished in', as.numeric(get_time() - t0, 'secs') ,'seconds'))
print(sprintf('Created %s interpretations (%s kept alive)',
              interp$counter, interp$ndescendants)
)

#Best explanation
print(cntr$best)
be = cntr$best$node
print(be$recover_all())

# return to original wd
setwd(currentPath)
