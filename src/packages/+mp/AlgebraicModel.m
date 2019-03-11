classdef AlgebraicModel < handle
%%AlgebraicModel is an abstract class. Its purpose is to provide interface to 
% models described by a system of algebraic (possibly nonlinear) equations.
  methods (Abstract)
    numOfDofs(obj) % return number of elements in state vector
    tangentMatrix(obj, state) % Return handle to tangent matrix
    isLinear(obj) % Return true if model is linear
    isSeparable(obj) % Return true if external forces do not depend on state vector
    isLoadingProportional(obj) % Return true if external forces are linear in stageParam
    residualVector(obj, state, stageParam)
    internalForces(obj, state)
    externalForces(obj, state, stageParam)
    loadsMatrix(obj, control)
    incrementalLoad(obj, state, stageParam)
    incrementalVelocity(obj, state, stageParam)
  end
end
