classdef ThermalProblem < mp.Problem 
  % Thermal problem calss 
  methods
    function [obj] = ThermalProblem(geometry)
      obj = obj@mp.Problem(mp.ProblemType.Thermal, geometry);
    end
    function setupVariables(obj)
      varname = 'Temperature';
      obj.addVariable(mp.Variable(varname, 1, mp.VariableType.State));
    end
  end
end
