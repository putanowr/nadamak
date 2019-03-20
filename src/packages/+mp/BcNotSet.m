classdef BcNotSet < mp.BoundaryCondition 
  methods
    function [obj] = BcNotSet(variable, params);
      obj = obj@mp.BoundaryCondition(mp.BcType.NotSet, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
