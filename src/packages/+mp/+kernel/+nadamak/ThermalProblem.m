classdef ThermalProblem < mp.Problem 
  % Mechanical problem calss 
  methods
    function [obj] = ThermalProblem(geometry)
      obj = obj@mp.Problem(mp.ProblemType.Thermal, geometry);
    end
    function assembly(obj, progress)
      progress.report(0.3, 'Assembly in Nadamak kernel');
    end
  end
end
