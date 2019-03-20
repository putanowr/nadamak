classdef BoundaryCondition < handle
  % Holds mesh data
  properties (SetAccess=private)
    type      mp.BcType
    variable
    value
  end
  methods
    function [obj] = BoundaryCondition(type, variableName, params)
      obj.type = type;
      obj.variable  = variableName;
      obj.setValue(params);
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
    function [status, msg] = setValue(obj, params)
      if isfield(params, 'value')
        if obj.validate(params)
          obj.value = params.value;
        else
          status = false;
          msg = 'BC value not valid'
        end
      end
    end
  end
  methods(Abstract)
    [status] = validate(obj, params);
  end
end
