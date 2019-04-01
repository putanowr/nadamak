classdef LShapeGeom < mp.GeomModel 
  % Geometric model for L-shpe.
  properties (Access=public)
    params = struct('dW', 3.0, 'dH', 5.0, 'dr',0.2, 'dt', 0.8, 'lcFactors', ones(1,12));
  end
  methods (Access=private)
    function setup(obj, params_)
      obj.params.dW = mp_get_option(params_, 'dW', obj.params.dW);
      obj.params.dH = mp_get_option(params_, 'dH', obj.params.dH);
      obj.params.dr = mp_get_option(params_, 'dr', obj.params.dr);
      obj.params.dt = mp_get_option(params_, 'dt', obj.params.dt);
      obj.params.lcFactors = mp_get_option(params_, 'lcFactors', obj.params.lcFactors);
    end
  end
  methods
    function [obj] = LShapeGeom(name, params, legacyID)
      if nargin < 3
        legacyID = 800 ;
      end
      if nargin < 2
        params = struct();
      end
      obj = obj@mp.GeomModel(name, 2, 2, legacyID);
      if ~isempty(params)
        obj.setup(params);
      end
    end
    function [geomgmsh] = as_gmsh(obj)
      tpl = fileread(fullfile(obj.templateDir, obj.templateName()));
      geomgmsh = mp_tpl_substitute(tpl, obj.params);
    end
    function [maxlc] = coarsest_lc(obj)
      maxlc = max(obj.params.dW, obj.params.dH);
    end
    function resetLcFactors(obj)
      obj.params.lcFactors = ones(size(obj.params.lcFactors));
    end
    function setSpecificLcFactors(obj, factor1, factor2)
      % Set lc factor at specific points
      obj.params.lcFactors([4,7,10]) = factor1;
      obj.params.lcFactors([3,5,6,8,9,11]) = factor2;
    end
    function [name] = templateName(obj)
      name = 'lshape.tpl';
    end
    function [regionNames] = regions(~)
      regionNames = {'domain', 'boundary', 'bottom', 'left', 'other'};
    end
  end
end
