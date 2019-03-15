classdef BcTraction < mp.BoundaryCondition 
  methods
    function [obj] = BcTraction(variable, params);
      obj = obj@mp.BoundaryCondition(mp.BcType.Traction, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
