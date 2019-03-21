classdef ModelVariable < handle
  % GeomModel Represents geometric model.
  properties(SetAccess=protected)
    variable
    meshFem
    dofs
  end
  methods
    function [obj] = ModelVariable(variable, params)
      obj.variable = variable;
      if isfield(params, 'fem')
        obj.meshFem = params.('fem');
      else
        obj.meshFem = [];
      end
      if ~isempty(obj.fem)
        dofs = zeros(obj.variable.numOfComponents, obj.fem.numOfDofs);
      else
        dofs = zeros(obj.variable.numOfComponents, 1);
      end
    end
    function [geomgmsh] = numOfDofs(obj)
      ndf = size(obj.dofs,1)*size(obj.dofs,2);
    end  
    function status = isFem(obj)
      status = ~isempty(obj.meshFem);
    end
  end
end
