classdef ThermalProblem < mp.ThermalProblem 
  % Mechanical problem calss 
  methods
    function [obj] = ThermalProblem(geometry)
      obj = obj@mp.ThermalProblem(geometry);
    end
    function assembly(obj, progress)
      obj.progress.report(0.3, 'Assembly in Calfem kernel');
    end
  end
end
