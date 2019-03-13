classdef MechanicalProblem < mp.Problem 
  % Mechanical problem calss 
  methods
    function [obj] = MechanicalProblem()
      obj = obj@mp.Problem(mp.ProblemType.Mechanical);
    end
  end
end
