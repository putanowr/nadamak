classdef ModelVariableRegistry < handle
  % Manages variables necessary for a FemModel
  properties (Access=private)
    vd struct % Structure with fields corresponding to variable names.
  end
  properties (SetAccess=private)
    offset uint32
  end
  methods
    function [obj] = ModelVariableRegistry()
      obj.vd = struct();
      obj.offset = 0;
    end
    function [status] = hasVariable(obj, variableName)
      status = isfield(obj.vd, variableName);
    end
    function [varNames] = names(obj)
      varNames = fieldnames(obj.vd)';
    end
    function [var] = get(obj, variableName)
      var = obj.vd.(variableName);
    end
    function createVariable(obj, variableName, fem)
    end
    function addVariable(obj, modelVariable)
      if modelVariable.isFem()
        ndof = modelVariable.fem.enumerateDofs();
      else
        ndof = prod(modelVariable.qdim);
      end
      modelVariable.setOffset(obj.offset);
      obj.vd.(modelVariable.variable.name) = modelVariable;
      obj.offset = obj.offset+ndof;
    end
  end
end
