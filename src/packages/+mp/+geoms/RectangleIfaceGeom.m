classdef RectangleIfaceGeom  < mp.GeomModel
  % Geometric model for Rectangle split into two subdomains.
  properties (Access=public)
    params = struct('dW', 2, 'dH', 3.0, 'lcFactors', [1,1,1,1,1,1]);
  end
  methods (Access=private)
    function setup(obj, params_)
      obj.params.dH = mp_get_option(params_, 'dH', obj.params.dH);
      obj.params.dW = mp_get_option(params_, 'dW', obj.params.dW);
      obj.params.lcFactors = mp_get_option(params_, 'lcFactors',...
                             obj.params.lcFactors);
    end
  end
  methods
    function [obj] = RectangleIfaceGeom(name, params, legacyID)
      if nargin < 3
        legacyID = 840 ;
      end
      if nargin < 2
        params = struct();
      end
      dim_ = 2;
      ambientdim_ = 2;
      obj = obj@mp.GeomModel(name, dim_, ambientdim_, legacyID);
      if ~isempty(params) 
        obj.setup(params);
      end
    end
    function [regionNames] = regions(~)
      regionNames = {'p_sw', ...
                     'p_se', ...
                     'p_ne', ...
                     'p_nw', ...
                     'p_sm', ...
                     'p_nm', ...
                     'b_left_south', ...
                     'b_right_south', ...
                     'b_east', ...
                     'b_right_north', ...
                     'b_left_north', ...
                     'b_west', ...
                     'i_interface', ...
                     'd_left', ...
                     'd_right'};
    end
    function [p1, p2] = getInterfaceEndpoints(obj)
      % Return coordinate vectors of interface endpoints
      p1 = [obj.params.dW/2, 0, 0];
      p2 = [obj.params.dW/2, obj.params.dH, 0];
    end
    function setCornerLcFactor(obj, factor)
      obj.params.lcFactors([1,3,4,6]) = factor;
    end
    function setInterfaceLcFactor(obj, factor)
      obj.params.lcFactors([2,5]) = factor;
    end
    function [name] = templateName(~)
      name = 'rectangle_iface.tpl';
    end
    function [lc] = coarsest_lc(obj)
      lc = max(obj.params.dW, obj.params.dH);
    end
  end
end
