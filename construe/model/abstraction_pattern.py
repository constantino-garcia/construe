# -*- coding: utf-8 -*-
# pylint: disable-msg=
"""
Created on Mon Jan 20 09:35:12 2014

This module provides the implementation of abstraction patterns, this is, the
necessary classes to allow the state representation and the execution of
automata-based patterns, as defined in the reference document.

@author: T. Teijeiro
"""

from .constraint_network import ConstraintNetwork, InconsistencyError, verify
from .automata import ABSTRACTED, BASIC_TCONST
from .FreezableObject import clone_attrs
import copy
import bisect
from collections import deque, Counter

class AbstractionPattern(object):
    """
    This class represents an abstraction pattern bounded to a pattern automata,
    and stores the "execution state" of the automata, which allows to explore
    the allowed transitions for each state and generate all the possible
    combinations of evidence consistent with the pattern.
    """
    __slots__ = ('automata', 'temporal_constraints', 'istate', 'fstate',
                 'trseq', 'hypothesis', 'evidence', 'findings')

    def __init__(self, automata):
        """
        Creates a new AbstractionPattern instance, bounded to a specific
        automata. It initializes the attributes of the class, which are the
        following:

        Instance Properties
        -------------------
        automata:
            Reference to the PatternAutomata object that describes the
            abstraction pattern.
        istate:
            Initial state of the current sequence of evidence observations.
        fstate:
            Final state of the current sequence of evidence observations.
        trseq:
            Sequence of tuples (transition, observation) that have been
            executed between the initial and final states, used to generate the
            observed evidence.
        hypothesis:
            Observation corresponding to the hypothesis generated by this
            pattern.
        evidence:
            Dictionary that maps every observable which is a terminal symbol of
            the automata definition with a list of the observations of that
            observable as evidence of the pattern.
        findings:
            Set containing those findings in the evidence that have still not
            matched to actual observations.
        temporal_constraints:
            List with temporal networks that are used to introduce the temporal
            knowledge in the pattern.
        """
        self.automata = automata
        self.temporal_constraints = []
        self.istate = self.fstate = automata.start_state
        self.trseq = []
        self.hypothesis = automata.Hypothesis()
        self.evidence = { obs : [] for obs in automata.manifestations}
        self.findings  = set()
        self.temporal_constraints.append(ConstraintNetwork())
        #We introduce the first basic constraints (start<=time<=end)
        BASIC_TCONST(self, self.hypothesis)

    def __str__(self):
        return str(self.automata)

    def __repr__(self):
        return str(self)

    def __copy__(self):
        """
        Perfroms a copy of this *AbstractionPattern* instance, copying
        the container types to allow further modifications. The hypothesis is
        deeply copied, but all the evidence observations and findings are
        shallowed copied.
        """
        cpy = AbstractionPattern(self.automata)
        cpy.istate = self.istate
        cpy.fstate = self.fstate
        cpy.trseq = self.trseq[:]
        cpy.temporal_constraints = []
        clone_attrs(cpy.hypothesis, self.hypothesis)
        for observable, observations in self.evidence.iteritems():
            cpy.evidence[observable] = observations[:]
        cpy.findings = self.findings.copy()
        for tnet in self.temporal_constraints:
            cpy.temporal_constraints.append(copy.copy(tnet))
            if cpy.last_tnet.contains_variable(self.hypothesis.start):
                cpy.last_tnet.substitute_variable(self.hypothesis.start,
                                                          cpy.hypothesis.start)
            if cpy.last_tnet.contains_variable(self.hypothesis.time):
                cpy.last_tnet.substitute_variable(self.hypothesis.time,
                                                          cpy.hypothesis.time)
            if cpy.last_tnet.contains_variable(self.hypothesis.end):
                cpy.last_tnet.substitute_variable(self.hypothesis.end,
                                                          cpy.hypothesis.end)
        return cpy

    def successors(self):
        """
        Allows the obtention of the valid successors of this abstraction
        pattern. These successors are calculated from the valid transitions of
        the automata from the current state, in both directions. All new
        generated observations are considered findings.
        """
        for trans in self.automata.tr_to(self.istate):
            pat = copy.copy(self)
            pat.istate = trans.istate
            newobs = trans.observable() if trans.observable else None
            if newobs is not None:
                pat.evidence[trans.observable].insert(0, newobs)
                pat.findings.add(newobs)
            pat.trseq.insert(0, (trans, newobs))
            #Because we travel the transition in inverse order, we have to
            #rebuild and recheck all the constraints from the initial to the
            #final state.
            pat.temporal_constraints = [ConstraintNetwork()]
            try:
                for i in xrange(len(pat.trseq)):
                    trans, obs = pat.trseq[i]
                    trans.tconst(pat, obs)
                    pat.check_temporal_consistency()
                    if all(o not in pat.findings for _, o in pat.trseq[:i+1]):
                        trans.gconst(pat, obs)
                yield pat
            except InconsistencyError:
                pass
        #We only go forward in the automata if we are already in an initial
        #state. The objective is to priorize to find the start of the pattern,
        #because these are the most expensive transitions.
        if self.istate == self.automata.start_state:
            for trans in self.automata.tr_from(self.fstate):
                pat = copy.copy(self)
                pat.fstate = trans.fstate
                newobs = trans.observable() if trans.observable else None
                if newobs is not None:
                    pat.evidence[trans.observable].append(newobs)
                    pat.findings.add(newobs)
                pat.trseq.append((trans, newobs))
                trans.tconst(pat, newobs)
                try:
                    pat.check_temporal_consistency()
                    #For empty string transitions, general constraints are
                    #inmediately checked.
                    if newobs is None:
                        trans.gconst(pat, newobs)
                    yield pat
                except InconsistencyError:
                    pass

    @property
    def last_tnet(self):
        """
        Obtains the reference to the last temporal network in this pattern.
        """
        return self.temporal_constraints[-1]

    @property
    def sufficient_evidence(self):
        """
        Checks if the evidence subsumed to the hypothesis of this pattern is
        sufficient to support the hypothesis.
        """
        return (not self.findings and self.istate is self.automata.start_state
                                  and self.fstate in self.automata.final_states)
    @property
    def obs_seq(self):
        """
        Obtains the sequence of observations of this pattern, in the current
        state.
        """
        return [obs for _, obs in self.trseq]

    def get_consecutive(self, observation):
        """
        Obtains the pair of observations (pred, suc) that are the predecessor
        and successor of a given observation within this pattern. In a
        consistent interpretation, the sequence (pred, observation, suc) must
        be consecutive, and no other observations of the same type must be
        in between. The returned values may be *None* if no such consecutivity
        constraints exist in the pattern.
        """
        lst = self.evidence[self.get_evidence_type(observation)[0]]
        idx = lst.index(observation)
        pred = None if idx == 0 else lst[idx-1]
        suc = None if idx == len(lst)-1 else lst[idx+1]
        return (pred, suc)

    def get_evidence_type(self, observation):
        """
        Obtains the type of evidence that an observation constitutes to this
        pattern instance, this is, the interpreted observable type and if it
        is an ABSTRACTED or ENVIRONMENT observation.
        """
        trans = next((tr for tr, obs in self.trseq if obs is observation), None)
        if trans is None:
            raise ValueError(
             'Observation {0} not related to this pattern'.format(observation))
        return (trans.observable, trans.abstracted)

    def get_step(self, observation):
        """
        Obtains the inference step in which an observation has been generated
        by this pattern. If the observation has not been inferred in this
        abstraction pattern instance, returns -1. The first step is 0.
        """
        return next((i for i in xrange(len(self.trseq))
                                       if self.trseq[i][1] is observation), -1)

    def abstracts(self, observation):
        """
        Checks if an observation, which must belong to the evidence of this
        pattern, is abstracted by it.
        """
        return self.get_evidence_type(observation)[1] is ABSTRACTED

    def replace(self, obs1, obs2):
        """
        Replaces the **obs1** observation by the **obs2** observation in this
        pattern, without checking knowledge consistency. All references to
        **obs1** will dissapear. **obs2** cannot be already present as evidence
        in this pattern.
        """
        if obs1 is obs2:
            return
        #Temporal variable replacement
        for tnet in self.temporal_constraints:
            if tnet.contains_variable(obs1.start):
                tnet.substitute_variable(obs1.start, obs2.start)
            if tnet.contains_variable(obs1.time):
                tnet.substitute_variable(obs1.time, obs2.time)
            if tnet.contains_variable(obs1.end):
                tnet.substitute_variable(obs1.end, obs2.end)
        #We get the transition that generated obs1
        tri = next((i for i in xrange(len(self.trseq))
                                            if self.trseq[i][1] is obs1), None)
        if tri is None:
            raise ValueError('Finding {0} not found'.format(obs1))
        trans = self.trseq[tri][0]
        self.trseq[tri] = (trans, obs2)
        lst = self.evidence[trans.observable]
        verify(isinstance(obs2, trans.observable), '{0} must be {1} instance',
                                                      (obs2, trans.observable))
        obsi = bisect.bisect_left(lst, obs1)
        obsi = next(i for i in xrange(obsi, len(lst)) if lst[i] is obs1)
        lst[obsi] = obs2
        verify(max(Counter(lst).itervalues()) == 1, 'Duplicated observation {0}'
                                      ' in {1} pattern evidence.', (obs2, self))
        if obs1 in self.findings:
            self.findings.remove(obs1)
            self.findings.add(obs2)

    def match(self, finding, observation):
        """
        Performs a matching of a finding belonging to the evidence of this
        pattern with an actual observation.
        """
        self.replace(finding, observation)
        #If the observation replaced a finding, it is not considered a finding
        #anymore.
        self.findings.discard(observation)
        #Once the replace is made, the temporal consistency of the pattern and
        #the general constraints of the transition have to be checked.
        self.check_temporal_consistency({observation.start, observation.time,
                                                              observation.end})
        tri = next((i for i in xrange(len(self.trseq))
                                     if self.trseq[i][1] is observation), None)
        #We check all the general constraints from the matched one to the end
        for i in xrange(tri, len(self.trseq)):
            trans, obs = self.trseq[i]
            if obs in self.findings:
                break
            trans.gconst(self, obs)

    def check_temporal_consistency(self, variables = None):
        """
        Checks the consistency of the temporal networks involved in this
        pattern instance, returning the set of temporal variables that have
        been modified in the minimization process.

        Parameters
        ----------
        variables:
            Iterable containing temporal variables. The procedure forces the
            minimization of the temporal networks containing any of these
            variables.

        Returns
        -------
        out:
            Set of *Variable* objects that have been modified in the
            consistency checking.
        """
        variables = variables or set()
        out = set()
        #We minimize the involved networks lazily
        queue = deque(n for n in self.temporal_constraints
                            if n.unconstrained or any(n.contains_variable(var)
                                                         for var in variables))
        while queue:
            tnet = queue.popleft()
            modified = tnet.minimize_network()
            #We add all the networks containing modified variables
            for var in modified:
                out.add(var)
                queue.extend({n for n in self.temporal_constraints
                                                  if n is not tnet and
                                                     n not in queue and
                                                     n.contains_variable(var)})
        return out

    def finish(self):
        """
        Executes the observation procedure of the associated automata,
        assigning proper values to all the attributes of the hypothesis. If the
        evidence is not sufficient, or if some constraint in the procedure
        fails, an *InconsistencyError* is raised.
        """
        if not self.sufficient_evidence:
            raise InconsistencyError('Not enough evidence to finish.')
        self.automata.obs_proc(self)

if __name__ == "__main__":
    pass