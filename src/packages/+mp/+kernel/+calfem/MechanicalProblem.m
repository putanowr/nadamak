classdef MechanicalProblem < mp.Problem 
  % Mechanical problem calss 
  methods
    function [obj] = MechanicalProblem()
      obj = obj@mp.Problem(mp.ProblemType.Mechanical);
    end
    function assembly(obj, progress)
      progress.report(0.3, 'Assembly in Calfem kernel');
    end
  end
end
