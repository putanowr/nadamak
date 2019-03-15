classdef BcDisplacement < mp.BoundaryCondition 
  methods
    function [obj] = BcDisplacement(variable, params);
      obj = obj@mp.BoundaryCondition(mp.BcType.Displacement, variable, params);
    end
    function [status] = validate(obj, params)
      return true;
    end
  end
end
