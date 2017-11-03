#' Observables
#' @aliases observable, observables
#' @description Base classes for all the observables.
#' @describeIn observables Base class for all the observables. It has three
#' attributes: \emph{start}, \emph{end} and \emph{time} (used to represent the
#' observable as a single event).
#' @seealso \link{CardiacCycle}, \link{CardiacRhythm},
#' \link{QRS}, \link{Deflection}.
#' @export
Observable = function() {
  CONSTRUE_MODULES$model$Observable()
}
attr(Observable, 'python_class') = 'construe.model.Observable'

#' @describeIn observables This type of observables have only one temporal 
#' variable, to which the two temporal variables of full observables are 
#' referenced.
#' @export
EventObservable = function() {
  CONSTRUE_MODULES$model$EventObservable()
}
attr(EventObservable, 'python_class') = 'construe.model.EventObservable'

# TODO: do we need CycleMeasurements?
#CycleMeasurements = namedtuple('CycleMeasurements', ['rr', 'rt', 'pq'])

# CardiacCycles -----------------------------------------------------------

#' Cardiac Cycle Observables
#' @aliases cardiac_cycle, cardiac_cycle_observable, cardiac_cycle_observables
#' @description Observables representing complete cardiac cycles.
#' @describeIn cardiac_cycle_observables This is the base class to represent 
#' cardiac cycles.
#' @seealso \link{observables}, \link{CardiacRhythm},
#' \link{QRS}, \link{Deflection}.
#' @export
CardiacCycle = function() {
  CONSTRUE_MODULES$knowledge$observables$CardiacCycles$CardiacCycle()
}
attr(CardiacCycle, 'python_class') = (
  'construe.knowledge.observables.CardiacCycles.CardiacCycle'
)

#' @describeIn cardiac_cycle_observables Class to represent the first heartbeat 
#' in an interpretation, used to break the recursion in the search for the 
#' previous beat.
#' @export
FirstBeat = function() {
  CONSTRUE_MODULES$knowledge$observables$CardiacCycles$FirstBeat()
}
attr(FirstBeat, 'python_class')= (
  'construe.knowledge.observables.CardiacCycles.FirstBeat'
)

#' @describeIn cardiac_cycle_observables This class represents a normal cardiac
#' cycle, with all its components.
#' @export
NormalCycle = function() {
  CONSTRUE_MODULES$knowledge$observables$CardiacCycles$Normal_Cycle()
} 
attr(NormalCycle, 'python_class') = (
  'construe.knowledge.observables.CardiacCycles.Normal_Cycle'
)


# Rhythms -----------------------------------------------------------------
#' Rhythm Observables
#' @aliases rhythm, rhythm_observables, rr 
#' @description Observables related with the cardiac rhythm analysis.
#' @describeIn rhythm_observables Class that represents a general and unspecified
#' cardiac rhythm
#' @export
CardiacRhythm = function() {
  CONSTRUE_MODULES$knowledge$observables$Rhythm$Cardiac_Rhythm()
}
attr(CardiacRhythm, 'python_class') = (
  'construe.knowledge.observables.Rhythm.Cardiac_Rhythm'
)

#' @describeIn rhythm_observables Class that represents the RR observable, this
#' is, the distance between two consecutive ventricular depolarizations.
#' @seealso \link{observables}, \link{CardiacCycle},
#' \link{QRS}, \link{Deflection}.
#' @export
RR = function() {
  CONSTRUE_MODULES$knowledge$observables$Rhythm$RR()
}
attr(RR, 'python_class') = 'construe.knowledge.observables.Rhythm.RR'

#' @describeIn rhythm_observables Class that represents the start of the first 
#' detected rhythm.
#' @export
RhythmStart = function() {
  CONSTRUE_MODULES$knowledge$observables$Rhythm$RhythmStart()
}
attr(RhythmStart, 'python_class') = (
  'construe.knowledge.observables.Rhythm.RhythmStart'
)

#' @describeIn rhythm_observables Class that represents a regular rhythm.
#' @export
RegularCardiacRhythm = function() {
  CONSTRUE_MODULES$knowledge$observables$Rhythm$RegularCardiacRhythm()
} 
attr(RegularCardiacRhythm, 'python_class') = (
  'construe.knowledge.observables.Rhythm.RegularCardiacRhythm'
)

#' @describeIn rhythm_observables Class that represents sinus rhythm.
#' @export
SinusRhythm = function() {
  CONSTRUE_MODULES$knowledge$observables$Rhythm$Sinus_Rhythm()
} 
attr(SinusRhythm, 'python_class') = (
  'construe.knowledge.observables.Rhythm.Sinus_Rhythm'
)

#' @describeIn rhythm_observables Class that represents tachycardia rhythm.
#' @export
Tachycardia = function() {
  CONSTRUE_MODULES$knowledge$observables$Rhythm$Tachycardia()
} 
attr(Tachycardia, 'python_class') = (
  'construe.knowledge.observables.Rhythm.Tachycardia'
)

#' @describeIn rhythm_observables Class that represents bradycardia rhythm.
#' @export
Bradycardia = function() {
  CONSTRUE_MODULES$knowledge$observables$Rhythm$Bradycardia()
} 
attr(Bradycardia, 'python_class') = (
  'construe.knowledge.observables.Rhythm.Bradycardia'
)

#' @describeIn rhythm_observables This class represents an extrasystole.
#' @export
Extrasystole = function() {
  CONSTRUE_MODULES$knowledge$observables$Rhythm$Extrasystole()
} 
attr(Extrasystole, 'python_class') = (
  'construe.knowledge.observables.Rhythm.Extrasystole'
)

#' @describeIn rhythm_observables This class represents a bigeminy rhythm.
#' @export
Bigeminy = function() {
  CONSTRUE_MODULES$knowledge$observables$Rhythm$Bigeminy()
} 
attr(Bigeminy, 'python_class') = 'construe.knowledge.observables.Rhythm.Bigeminy'

#' @describeIn rhythm_observables This class represents a trigeminy rhythm.
#' @export
Trigeminy = function() {
  CONSTRUE_MODULES$knowledge$observables$Rhythm$Trigeminy()
} 
attr(Trigeminy, 'python_class') = (
  'construe.knowledge.observables.Rhythm.Trigeminy'
)

#' @describeIn rhythm_observables Class that represents an asystole (absence of
#' cardiac activity).
#' @export
Asystole = function() {
  CONSTRUE_MODULES$knowledge$observables$Rhythm$Asystole()
} 
attr(Asystole, 'python_class') = (
  'construe.knowledge.observables.Rhythm.Asystole'
)

#' @describeIn rhythm_observables Class that represents a ventricular flutter 
#' rhythm.
#' @export
VentricularFlutter = function() {
  CONSTRUE_MODULES$knowledge$observables$Rhythm$Ventricular_Flutter()
} 
attr(VentricularFlutter, 'python_class') = (
  'construe.knowledge.observables.Rhythm.Ventricular_Flutter'
)

#' @describeIn rhythm_observables Class that represents a ventricular couplet 
#' rhythm.
#' @export
Couplet = function() {
  CONSTRUE_MODULES$knowledge$observables$Rhythm$Couplet()
} 
attr(Couplet, 'python_class') = (
  'construe.knowledge.observables.Rhythm.Couplet'
)

#' @describeIn rhythm_observables Class that represents a rhythm block.
#' @export
RhythmBlock = function() {
  CONSTRUE_MODULES$knowledge$observables$Rhythm$RhythmBlock()
} 
attr(RhythmBlock, 'python_class') = (
  'construe.knowledge.observables.Rhythm.RhythmBlock'
)

#' @describeIn rhythm_observables Class that represents atrial fibrillation.
AtrialFibrillation = function() {
  CONSTRUE_MODULES$knowledge$observables$Rhythm$Atrial_Fibrillation()
} 
attr(AtrialFibrillation, 'python_class') = (
  'construe.knowledge.observables.Rhythm.Atrial_Fibrillation'
)

# Segmentation ------------------------------------------------------------

#' Segmentation observables
#' @aliases segmentation, segmentation_observables, qrs, t-wave, p-wave
#' @description Observables related with the segmentation of the ECG signal in
#' components.
#' @describeIn segmentation_observables Observable that represents a QRS complex
#' and its shape by lead.
#' @export
QRS = function() {
  CONSTRUE_MODULES$knowledge$observables$Segmentation$QRS()
}
attr(QRS, 'python_class') = 'construe.knowledge.observables.Segmentation.QRS'

#' @describeIn segmentation_observables  Observable that represents a P Wave.
#' @seealso \link{observables}, \link{CardiacCycle},
#' \link{CardiacRhythm}, \link{Deflection}.
#' @export
PWave = function() {
  CONSTRUE_MODULES$knowledge$observables$Segmentation$PWave()
}
attr(PWave, 'python_class') = 'construe.knowledge.observables.Segmentation.PWave'

#' @describeIn segmentation_observables Observable that represents a T Wave.
#' @export
TWave = function() {
  CONSTRUE_MODULES$knowledge$observables$Segmentation$TWave()
}
attr(TWave, 'python_class') = 'construe.knowledge.observables.Segmentation.TWave'

#' @describeIn segmentation_observables Class that represents the shape of a QRS
#' complex in a specific leads. It consists in a sequence of waves, a string tag
#' abstracting those waves, an amplitude and energy and maximum slope measures,
#' and a numerical array representing the signal.  
#' @export
QRSShape = function() {
  CONSTRUE_MODULES$knowledge$observables$Segmentation$QRSShape()
} 
attr(QRSShape, 'python_class') = (
  'construe.knowledge.observables.Segmentation.QRSShape'
)

#' @describeIn segmentation_observables Observable that represents a noisy signal
#' fragment. 
#' @export
Noise = function() {
  CONSTRUE_MODULES$knowledge$observables$Segmentation$Noise()
} 
attr(Noise, 'python_class') = (
  'construe.knowledge.observables.Segmentation.Noise'
)

#' @describeIn segmentation_observables Observable that represents a R wave peak. 
#' @export
RPeak = function() {
  CONSTRUE_MODULES$knowledge$observables$Segmentation$RPeak()
} 
attr(RPeak, 'python_class') = 'construe.knowledge.observables.Segmentation.RPeak'

#' @describeIn segmentation_observables Observable that represents a baseline 
#' observation.
#' @export
Baseline = function() {
  CONSTRUE_MODULES$knowledge$observables$Segmentation$Baseline()
} 
attr(Baseline, 'python_class') = (
  'construe.knowledge.observables.Segmentation.Baseline'
)

# Spectrum ----------------------------------------------------------------
#' Spectrum observables
#' @aliases spectrum, spectrum_observables, spectrum_observable, deflection
#' @description Observables related with the spectrum analysis of the ECG signal.
#' @describeIn spectrum_observables This class represents a signal deviation 
#' consistent with the electrical activity of the cardiac muscle fibers. It is 
#' associated with a certain energy level derived from the wavelet 
#' decomposition/reconstruction  of the signal. 
#' @seealso \link{observables}, \link{CardiacCycle},
#' \link{CardiacRhythm}, \link{QRS}.
#' @export
Deflection = function() {
  CONSTRUE_MODULES$knowledge$observables$Spectrum$Deflection()
}
attr(Deflection, 'python_class') = (
  'construe.knowledge.observables.Spectrum.Deflection'
)

#' @describeIn spectrum_observables This class represents a signal deviation 
#' consistent with the electrical activity generated in the ventricular
#' activation. It can be obtained by any external QRS detection algorithm.
#' @export
RDeflection = function() {
  CONSTRUE_MODULES$knowledge$observables$Spectrum$RDeflection()
}
attr(RDeflection, 'python_class') = (
  'construe.knowledge.observables.Spectrum.RDeflection'
)
