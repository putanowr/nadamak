classdef NotchedRQGeom < mp.GeomModel 
  % Geometric model for a quarter of notched rectangle.
   properties (Access=public)
    params = struct();
  end
  methods(Access=private)
    function setup(obj, params_)
    end
  end
  methods
    function [obj] = NotchedRQGeom(name, params, legacyID)
      if nargin < 3
        legacyID = 810;
      end
      if nargin < 2
        params = struct();
      end
      obj = obj@mp.GeomModel(name, 2, legacyID);
      if ~isempty(params)
        obj.setup(params);
      end
    end
    function [regionNames] = regions(obj)
      regionNames = {'d_whole'};
    end
    function [name] = templateName(obj)
      name = 'notchedrectquarter.tpl';
    end
    function [maxlc] = coarsest_lc(obj)
      maxlc = 1;
    end
  end
end
