classdef BcFixityXZ < mp.BoundaryCondition 
  methods
    function [obj] = BcFixityXZ(variable, params)
      if nargin < 2
        params = struct();
      end
      params.value = [0, missing, 0];
      obj = obj@mp.BoundaryCondition(mp.BcType.FixityXZ, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
