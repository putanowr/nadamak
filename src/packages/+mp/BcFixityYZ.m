classdef BcFixityYZ < mp.BoundaryCondition 
  methods
    function [obj] = BcFixityYZ(variable, params)
      if nargin < 2
        params = struct();
      end
      params.value = [missing, 0, 0];
      obj = obj@mp.BoundaryCondition(mp.BcType.FixityYZ, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
