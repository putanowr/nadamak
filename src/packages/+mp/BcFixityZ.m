classdef BcFixityZ < mp.BoundaryCondition 
  methods
    function [obj] = BcFixityZ(variable, params)
      if nargin < 2
        params = struct();
      end
      params.value = [missing, missing, 0];
      obj = obj@mp.BoundaryCondition(mp.BcType.FixityZ, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
