classdef NotchedRQGeom < mp.GeomModel 
  % Geometric model for a quarter of notched rectangle.
  properties (Access=public)
    params = struct('dW', 2, 'dH', 3, 'dR', 1, 'amid', 0.5);
  end
  methods(Access=private)
    function setup(obj, params_)
      obj.params.dW = mp_get_option(params_, 'dW', obj.params.dW);
      obj.params.dH = mp_get_option(params_, 'dH', obj.params.dH);
      obj.params.dR = mp_get_option(params_, 'dR', obj.params.dR);
      obj.params.amid = mp_get_option(params_, 'amid', obj.params.amid);
    end
  end
  methods
    function [obj] = NotchedRQGeom(name, params, legacyID)
      if nargin < 3
        legacyID = 810 ;
      end
      if nargin < 2
        params = struct();
      end
      obj = obj@mp.GeomModel(name, params, legacyID);
      if ~isempty(params)
        obj.setup(params);
      end
    end
    function [regionNames] = regions(obj)
      regionNames = {}
    end
    function [name] = templateName(obj)
      name = 'notchedrectquarter.tpl';
    end
    function [maxlc] = coarsest_lc(obj)
      maxlc = 1;
    end
  end
end
