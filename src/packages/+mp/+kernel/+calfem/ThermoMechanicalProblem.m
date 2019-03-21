classdef ThermoMechanicalProblem < mp.ThermoMechanicalProblem 
  % Mechanical problem calss 
  methods
    function [obj] = ThermoMechanicalProblem(geometry)
      obj = obj@mp.ThermoMechanicalProblem(geometry);
    end
    function assembly(obj, progress)
      obj.progress.report(0.3, 'Assembly in Calfem kernel');
    end
  end
end
