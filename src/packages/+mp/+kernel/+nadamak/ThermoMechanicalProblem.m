classdef ThermoMechanicalProblem < mp.Problem 
  % Mechanical problem calss 
  methods
    function [obj] = ThermoMechanicalProblem(geometry)
      obj = obj@mp.Problem(mp.ProblemType.ThermoMechanical, geometry);
    end
    function assembly(obj, progress)
      progress.report(0.3, 'Assembly in Nadamak kernel');
    end
  end
end
