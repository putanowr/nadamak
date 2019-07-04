classdef BcFixityX < mp.BoundaryCondition 
  methods
    function [obj] = BcFixityX(variable, params)
      if nargin < 2
        params = struct();
      end
      params.value = [0, missing, missing];
      obj = obj@mp.BoundaryCondition(mp.BcType.FixityX, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
