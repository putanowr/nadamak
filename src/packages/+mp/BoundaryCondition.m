classdef BoundaryCondition < handle
  % Holds mesh data 
  properties (SetAccess=private)
    type      mp.BcType
    variable  
  end
  methods
    function [obj] = BoundaryCondition(type, variableName, params)
      obj.type = type;
      obj.variable  = variableName;
    end
    function flag = isActive(obj, variableName)
      % Return true if BC is set for variable
      if obj.type == mp.BcType.NotSet
        flag = false;
      else
        flag = true;
        if ~isempty(variableName)
          flag = strcmp(obj.variable, variableName);
        end
      end
    end
  end
  methods(Abstract)
    [status] = validate(obj, params);    
  end
end
