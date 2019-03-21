classdef VariableRegistry < handle
  % Manages variables necessary for a Problem
  properties (Access=private)
    vd struct % Structure with fields corresponding to variable names.
  end
  methods
    function [obj] = VariableRegistry()
      obj.vd = struct();
    end
    function addFEMVariable(obj, variableName, fem);
    end
  end
end
