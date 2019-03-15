classdef BcFixityZ < mp.BoundaryCondition 
  methods
    function [obj] = BcFixityZ(variable, params);
      obj = obj@mp.BoundaryCondition(mp.BcType.FixityZ, variable, params);
    end
    function [status] = validate(obj, params)
      return true;
    end
  end
end
