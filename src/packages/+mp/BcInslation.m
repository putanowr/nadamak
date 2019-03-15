classdef BcInsulation < mp.BoundaryCondition 
  methods
    function [obj] = BcInsulation(variable, params);
      obj = obj@mp.BoundaryCondition(mp.BcType.Insulation, variable, params);
    end
    function [status] = validate(obj, params)
      return true;
    end
  end
end
