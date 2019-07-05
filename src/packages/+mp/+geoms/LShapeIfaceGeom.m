classdef LShapeIfaceGeom < mp.geoms.LShapeGeom 
  % Geometric model for L-shpe split into two subdomains.
  methods(Access=private)
    function setup(obj, params_)
      obj.params.fA = mp_get_option(params_, 'fA', 0.5);
      obj.params.fB = mp_get_option(params_, 'fB', 0.5);
      obj.params.quads = [0, 0];
      obj.params.lcFactors = ones(1, 14);
    end
  end
  methods
    function [obj] = LShapeIfaceGeom(name, params, legacyID)
      if nargin < 3
        legacyID = 810 ;
      end
      if nargin < 2
        params = struct();
      end
      obj = obj@mp.geoms.LShapeGeom(name, params, legacyID);
      if ~isempty(params)
        obj.setup(params);
      end
    end
    function [regionNames] = regions(obj)
      regionNames = {'d_subBottom', ...
                     'd_subTop', ...
                     'b_bottom', ...
                     'b_left_top', ...
                     'b_left_bottom', ...
                     'b_other_bottom', ...
                     'b_other_top', ...
                     'i_interface'};
    end
    function [p1, p2] = getInterfaceEndpoints(obj)
      % Return coordinate vectors of interface endpoints
      p1 = [0, obj.params.fA*obj.params.dH, 0];
      fB = obj.params.fB;
      t = obj.params.dt;
      r = obj.params.dr;
      h = obj.params.dH;
      p2 = [obj.params.dt, (1-fB)*(t+r)+fB*(h-r), 0];
    end
    function setSpecificLcFactors(obj, factor1, factor2)
      % Set lc factor at specific points
      obj.params.lcFactors([4,7,10]) = factor1;
      obj.params.lcFactors([3,5,6,8,9,11]) = factor2;
    end
    function setInterfaceLcFactor(obj, factor)
      obj.params.lcFactors([13,14]) = factor;
    end
    function [name] = templateName(obj)
      name = 'lshape_interface.tpl';
    end
  end
end
