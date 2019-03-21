classdef ThermoMechanicalProblem < mp.Problem 
  % ThermoMechanical problem calss 
  methods
    function [obj] = ThermoMechanicalProblem(geometry)
      obj = obj@mp.Problem(mp.ProblemType.ThermoMechanical, geometry);
    end
    function setupVariables(obj)
      d = obj.geometry.dim;
      varname = 'u';
      obj.variables.(varname) = mp.Variable(varname, d, mp.VariableType.State);
      varname = 'T';
      obj.variables.(varname) = mp.Variable(varname, 1, mp.VariableType.State);
    end
  end
end
