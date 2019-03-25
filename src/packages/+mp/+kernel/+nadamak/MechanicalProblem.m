classdef MechanicalProblem < mp.MechanicalProblem 
  % Mechanical problem calss 
  methods
    function [obj] = MechanicalProblem(geometry)
      obj = obj@mp.MechanicalProblem(geometry);
    end
    function assembly(obj, options)
      obj.progress.report(0.3, 'Assembly in Nadamak kernel');
    end
  end
end
