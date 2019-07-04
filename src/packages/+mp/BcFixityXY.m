classdef BcFixityXY < mp.BoundaryCondition 
  methods
    function [obj] = BcFixityXY(variable, params)
      obj = obj@mp.BoundaryCondition(mp.BcType.FixityXY, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
