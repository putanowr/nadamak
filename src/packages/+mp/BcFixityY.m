classdef BcFixityY < mp.BoundaryCondition 
  methods
    function [obj] = BcFixityY(variable, params)
      if nargin < 2
        params = struct();
      end
      params.value = [missing, 0, missing];
      obj = obj@mp.BoundaryCondition(mp.BcType.FixityY, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
