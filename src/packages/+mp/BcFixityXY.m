classdef BcFixityXY < mp.BoundaryCondition 
  methods
    function [obj] = BcFixityXY(variable, params)
      if nargin < 2
        params = struct();
      end
      params.value = [0,0, missing];
      obj = obj@mp.BoundaryCondition(mp.BcType.FixityXY, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
