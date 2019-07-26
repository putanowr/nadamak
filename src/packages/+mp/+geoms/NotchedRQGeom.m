classdef NotchedRQGeom < mp.GeomModel 
  % Geometric model for a quarter of notched rectangle.
  properties (Access=public)
    params = struct('dW', 2, 'dH', 3, 'dR', 1, 'amid', 0.5,...
    'lcFactors', [1,1,1,1,1,1], 'singlesurf', 1);
  end
  methods(Access=private)
    function setup(obj, params_)
      obj.ntransdir = 3;
      obj.params.dW = mp_get_option(params_, 'dW', obj.params.dW);
      obj.params.dH = mp_get_option(params_, 'dH', obj.params.dH);
      obj.params.dR = mp_get_option(params_, 'dR', obj.params.dR);
      obj.params.amid = mp_get_option(params_, 'amid', obj.params.amid);
      obj.params.singlesurf = mp_get_option(params_, 'singlesurf',...
                                            obj.params.singlesurf);
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
      obj = obj@mp.GeomModel(name, 2, 2, legacyID);
      if ~isempty(params)
        obj.setup(params);
      end
    end
    function [regionNames] = regions(obj)
      if obj.singlesurf
        regionNames = {'p_sw', 'p_arc_start', 'p_arc_mid', 'p_arc_end', ...
                       'p_ne', 'p_nw', ...
                       'b_south', ...
                       'b_arc_s', 'b_arc_n', ...
                       'b_east', 'b_north', 'b_west', ...
                       'd_domain'};
      else
        regionNames = {'p_sw', 'p_arc_start', 'p_arc_mid', 'p_arc_end', ...
                       'p_ne', 'p_nw', ...
                       'b_south', ...
                       'b_arc_s', 'b_arc_n', ...
                       'b_east', 'b_north', 'b_west', ...
                       'i_interface', ...
                       'd_bottom', 'd_top'};
      end                 
    end
    function [name] = templateName(obj)
      name = 'notchedrectquarter.tpl';
    end
    function [maxlc] = coarsest_lc(obj)
      maxlc = 1;
    end
  end
end
