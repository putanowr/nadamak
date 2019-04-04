classdef ModelVariable < handle
  % GeomModel Represents geometric model.
  properties(SetAccess=protected)
    variable
    fem
    offset
  end
  properties
    dofValues
  end
  methods
    function [obj] = ModelVariable(variable, params)
      obj.variable = variable;
      obj.offset = 0;
      if isfield(params, 'fem')
        obj.fem = params.('fem');
      else
        obj.fem = [];
      end
      if ~isempty(obj.fem)
        obj.dofValues = zeros(obj.fem.numOfDofs,1);
      else
        obj.dofValues = zeros(obj.variable.numOfComponents, 1);
      end
    end
    function setOffset(obj, offset)
      obj.offset = offset;
    end
    function [ndf] = numOfDofs(obj)
      ndf = obj.fem.numOfDofs;
    end  
    function status = isFem(obj)
      status = ~isempty(obj.fem);
    end
  end
end
