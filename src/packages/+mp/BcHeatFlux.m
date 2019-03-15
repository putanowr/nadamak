classdef BcHeatFlux < mp.BoundaryCondition 
  methods
    function [obj] = BcHeatFlux(variable, params);
      obj = obj@mp.BoundaryCondition(mp.BcType.HeatFlux, variable, params);
    end
    function [status] = validate(obj, params)
      return true;
    end
  end
end
