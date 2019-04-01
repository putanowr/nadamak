classdef TSHGeom < mp.GeomModel 
  % Geometric model with twin squares topology. It consist of two subdomains
  % with optional two circular voids. 
  properties (Access=public)
    dW = 2.0; % side length
    dH = 1.0;
    dbottom = 1.0;
    dtop = 1.5;
    dmx = 1.0;
    dmy = 0.5;
    curved = false;
    insetsXYR = zeros(2,3);
    insetsN = zeros(1,2);
    insetsType = zeros(1,2);
    quads = [0, 0];
    nxelems = [5,5];
    nyelems = [5,5];
    structured = [0, 0];
  end
  methods (Access=private)
    function setup(obj, params)
      obj.dW = mp_get_option(params, 'dW', obj.dW);
      obj.dH = mp_get_option(params, 'dH', obj.dH);
      obj.dbottom = mp_get_option(params, 'dbottom', 0.5*obj.dW);
      obj.dtop = mp_get_option(params, 'dtop', 0.75*obj.dW);
      obj.dmx = mp_get_option(params, 'dmx', 0.5*obj.dW);
      obj.dmy = mp_get_option(params, 'dmy', 0.5*obj.dH);
      obj.curved = mp_get_option(params, 'curved', obj.curved);
      obj.quads = mp_get_option(params, 'quads', obj.quads);
      obj.nxelems = mp_get_option(params, 'nxelems', obj.nxelems);
      obj.nyelems = mp_get_option(params, 'nyelems', obj.nyelems);
      obj.structured = mp_get_option(params, 'structured', obj.structured);
    end
  end
  methods
    function [name] = templateName(~)
      name = 'tsh.tpl';
    end
    function [regionNames] = regions(~)
      regionNames = {'domain', 'boundary', 'corners', 'left_boundary', ...
                     'rgith_boundary', 'left', 'right'};
    end
    function [obj] = TSHGeom(name, params, legacyID)
      if nargin < 3
        legacyID = 8 ;
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
      params.insets = obj.insetsType;
      params.insets_x = obj.insetsXYR(:,1);
      params.insets_y = obj.insetsXYR(:,2);
      params.insets_R = obj.insetsXYR(:,3);
      params.insets_N = obj.insetsN;
      params.nyelems = obj.nyelems(1);
      for paramName = {'dW', 'dH', 'dbottom', 'dtop', 'dmx', 'dmy', 'curved', ...
                       'structured', 'quads', 'nxelems'}
        params.(paramName{:}) = obj.(paramName{:});
      end
      geomgmsh = mp_geom_tsh(params);
    end
    function [maxlc] = coarsest_lc(obj)
      maxlc = obj.dW;
    end
  end
end
