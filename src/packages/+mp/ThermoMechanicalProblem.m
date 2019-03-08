classdef ThermoMechanicalProblem < mp.Problem 
  % ThermoMechanical problem calss 
  methods
    function [obj] = ThermoMechanicalProblem()
      obj = obj@mp.Problem(mp.ProblemType.ThermoMechanical);
    end
  end
end
