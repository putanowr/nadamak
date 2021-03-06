classdef BcFixityX < mp.BoundaryCondition 
  methods
    function [obj] = BcFixityX(variable, params);
      obj = obj@mp.BoundaryCondition(mp.BcType.FixityX, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
