classdef TriangleGeom < mp.GeomModel 
  % Geometric model of a square.
  properties (Access = public)
    params = struct('A', [0,0], 'B', [1,0], 'C', [0,1], 'lcFactors', [1,1,1]);
  end
  methods (Access=private)
    function setup(obj, params_)
      obj.params.lcFactors = mp_get_option(params_, 'lcFactors', obj.params.lcFactors);
    end
  end
  methods
    function [obj] = TriangleGeom(name, params_, legacyID)
      if nargin < 3
        legacyID = 0;
      end 
      if nargin < 2
         params_ = struct();
      end
      obj = obj@mp.GeomModel(name, 2, 2, legacyID);
      if ~isempty(params_)
        obj.setup(params_);
      end
    end
    function [regionNames] = regions(~)
      regionNames = {'d_domain', 'b_AB', 'b_BC', 'b_CA', 'p_corners' };
    end
    function [name] = templateName(~)
      name = 'triangle.tpl';
    end
    function [geomgmsh] = as_gmsh(obj)
      geomgmsh = mp_geom_triangle(obj.params.A, obj.params.B, obj.params.C, obj.params);
    end
    function [pts] = vertices(obj)
      pts = [obj.params.A;obj.params.B;obj.params.C];
    end
    function [maxlc] = coarsest_lc(obj)
      pts = obj.vertices();
      pts(end+1,:) = pts(1,:);
      de = diff(pts, 1);
      d = sqrt(de(:,1).^2 + de(:,2).^2);
      maxlc = max(d);
    end
  end
end
