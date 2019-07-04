classdef BcFixityXZ < mp.BoundaryCondition 
  methods
    function [obj] = BcFixityXZ(variable, params)
      obj = obj@mp.BoundaryCondition(mp.BcType.FixityXZ, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
