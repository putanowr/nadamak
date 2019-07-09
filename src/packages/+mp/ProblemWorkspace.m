classdef ProblemWorkspace < handle
  % This callas manages data for Problem. Problem instances can store
  % here by name 
  properties (Access=private)
    vd % Structure with fields corresponding to variable names.
  end
  methods
    function [obj] = ProblemWorkspace()
      obj.vd = struct();
    end
    function addData(obj, name, data, overwrite)
      if nargin < 4
        overwrite = true;
      end
      if overwrite
          obj.vd.(name) = data;
      else
        error('Overwriting existing data : %s\n', name);
      end
    end
    function [status] = hasDataFor(obj, name)
      status = isfield(obj.vd, name);
    end
    function [varNames] = names(obj)
      varNames = fieldnames(obj.vd)';
    end
    function [var] = getData(obj, name)
      var = obj.vd.(name);
    end
  end
end
