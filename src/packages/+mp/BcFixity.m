classdef BcFixity < mp.BoundaryCondition 
  methods
    function [obj] = BcFixity(variable, params)
      if nargin < 2
        params = struct();
      end
      params.value = [0,0,0];
      obj = obj@mp.BoundaryCondition(mp.BcType.Fixity, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
