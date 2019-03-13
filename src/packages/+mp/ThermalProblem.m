classdef ThermalProblem < mp.Problem 
  % Thermal problem calss 
  methods
    function [obj] = ThermalProblem()
      obj = obj@mp.Problem(mp.ProblemType.Thermal);
    end
  end
end
