classdef BcForce < mp.BoundaryCondition 
  methods
    function [obj] = BcForce(variable, params);
      obj = obj@mp.BoundaryCondition(mp.BcType.Force, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
