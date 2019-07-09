classdef MechanicalProblem < mp.Problem
  % Mechanical problem calss
  methods
    function [obj] = MechanicalProblem(geometry)
      obj = obj@mp.Problem(mp.ProblemType.Mechanical, geometry);
    end
    function setupVariables(obj)
      d = obj.geometry.dim;
      varname = 'Displacement';
      obj.addVariable(mp.Variable(varname, d, mp.VariableType.State));
    end
    function addGravity(obj, gravityVec)
      % Adds 'gravity' parameter to the problem
      d = obj.geometry.dim;
      if nargin < 2
        gravityVec(d) = -9.81;
      end
      if numel(gravityVec) ~= d
        error('Inconsisten size for gravity vector: geom is %d-dim, vec is %d-dim', d, numel(gravityVec));
      end
      variable = mp.Variable('gravity', d, mp.VariableType.Data);
      obj.myspace.addData('gravity', gravityVec(1:d));
      obj.addVariable(variable);
    end
  end
end
