classdef BcFixityY < mp.BoundaryCondition 
  methods
    function [obj] = BcFixityY(variable, params);
      obj = obj@mp.BoundaryCondition(mp.BcType.FixityY, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
