classdef BoundaryCondition < handle
  % Holds mesh data 
  properties (SetAccess=private)
    type      mp.BcType
    variable  
  end
  methods
    function [obj] = BoundaryCondition(type, variable, params)
      obj.type = type;
      obj.variable  = variable;
    end
  end
  methods(Abstact)
    [status] = validate(obj, params);    
  end
end
