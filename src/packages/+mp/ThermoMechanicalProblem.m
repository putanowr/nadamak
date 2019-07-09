classdef ThermoMechanicalProblem < mp.Problem 
  % ThermoMechanical problem calss 
  methods
    function [obj] = ThermoMechanicalProblem(geometry)
      obj = obj@mp.Problem(mp.ProblemType.ThermoMechanical, geometry);
    end
    function setupVariables(obj)
      d = obj.geometry.dim;
      obj.addVariable(mp.Variable('Displacement', d, mp.VariableType.State));
      obj.addVariable(mp.Variable('Temperature',  1, mp.VariableType.State));
    end
  end
end
