classdef BcPressure < mp.BoundaryCondition 
  methods
    function [obj] = BcPressure(variable, params)
      obj = obj@mp.BoundaryCondition(mp.BcType.Pressure, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
