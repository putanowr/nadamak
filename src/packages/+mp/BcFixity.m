classdef BcFixity < mp.BoundaryCondition 
  methods
    function [obj] = BcFixity(variable, params);
      obj = obj@mp.BoundaryCondition(mp.BcType.Fixity, variable, params);
    end
    function [status] = validate(obj, params)
      status = true;
    end
  end
end
