classdef MechanicalProblem < mp.Problem 
  % Mechanical problem calss 
  methods
    function [obj] = MechanicalProblem(geometry)
      obj = obj@mp.Problem(mp.ProblemType.Mechanical, geometry);
    end
    function setupVariables(obj)
      d = obj.geometry.dim;
      varname = 'Displacement';
      obj.variables.(varname) = mp.Variable(varname, d, mp.VariableType.State); 
    end
  end
end
