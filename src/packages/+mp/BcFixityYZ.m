classdef BcFixityYZ < mp.BoundaryCondition 
  methods
    function [obj] = BcFixityYZ(variable, params)
      obj = obj@mp.BoundaryCondition(mp.BcType.FixityYZ, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
