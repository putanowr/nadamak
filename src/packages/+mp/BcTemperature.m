classdef BcTemperature < mp.BoundaryCondition 
  methods
    function [obj] = BcTemperature(variable, params);
      obj = obj@mp.BoundaryCondition(mp.BcType.Temperature, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
