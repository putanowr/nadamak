classdef MechanicalProblem < mp.Problem 
  % Mechanical problem calss 
  methods
    function [obj] = MechanicalProblem(geometry)
      obj = obj@mp.Problem(mp.ProblemType.Mechanical, geometry);
    end
    function assembly(obj, progress)
      obj.progress.report(0.3, 'Assembly in Calfem kernel');
    end
  end
end
