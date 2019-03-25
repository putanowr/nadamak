classdef ThermalProblem < mp.Problem 
  % Thermal problem calss 
  methods
    function [obj] = ThermalProblem(geometry)
      obj = obj@mp.Problem(mp.ProblemType.Thermal, geometry);
    end
    function setupVariables(obj)
      varname = 'T';
      obj.variables.(varname) = mp.Variable(varname, 1, mp.VariableType.State); 
    end
  end
end
