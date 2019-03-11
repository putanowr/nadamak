classdef RectangleGeom < mp.GeomModel 
  % Geometric model of a rectangle.
  properties (Access = public)
    params = struct('da', 2.0, 'db', 1.0, 'lcFactors', [1,1,1,1]);
  end
  methods (Access=private)
    function setup(obj, params_)
      obj.params.da = mp_get_option(params_, 'da', obj.params.da);
      obj.params.db = mp_get_option(params_, 'db', obj.params.db);
      obj.params.lcFactors = mp_get_option(params_, 'lcFactors', obj.params.lcFactors);
    end
  end
  methods
    function [obj] = RectangleGeom(name, params_, legacyID)
      if nargin < 3
        legacyID = 10;
      end
      if nargin < 2
        params_ = struct();
      end
      obj = obj@mp.GeomModel(name, 2, legacyID);
      if ~isempty(params_)
        obj.setup(params_);
      end
    end
    function [name] = templateName(~)
      name = 'rectangle.tpl';
    end
    function [regionNames] = regions(~)
      regionNames = {'d_domain', 'b_south', 'b_east', 'b_north', 'b_west',...
                     'p_corners'};
    end
    function [geomgmsh] = as_gmsh(obj)
      p1 = [0, 0];
      p2 = [obj.params.da, obj.params.db];  
      geomgmsh = mp_geom_rectangle(p1, p2, obj.params);
    end
    function [maxlc] = coarsest_lc(obj)
      maxlc = max(obj.params.da, obj.params.db);
    end
  end
end
