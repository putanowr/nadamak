classdef SegmentGeom < mp.GeomModel 
  % Geometric model of segment.
  properties (Access = public)
    params = struct('dL', 1.0, 'lcFactors', [1,1]);
  end
  methods (Access=private)
    function setup(obj, params_)
      obj.params.dL = mp_get_option(params_, 'dL', obj.params.dL);
      obj.params.lcFactors = mp_get_option(params_, 'lcFactors', obj.params.lcFactors);
    end
  end
  methods
    function [obj] = SegmentGeom(name, params_, legacyID)
      if nargin < 3
        legacyID = 10;
      end
      if nargin < 2
        params_ = struct();
      end
      obj = obj@mp.GeomModel(name, 1, 2, legacyID);
      if ~isempty(params_)
        obj.setup(params_);
      end
    end
    function [name] = templateName(~)
      name = 'segment.tpl';
    end
    function [regionNames] = regions(~)
      regionNames = {'d_domain', 'p_endpoints'};
    end
    function [geomgmsh] = as_gmsh(obj)
      prms = obj.params;
      prms.pt1 = [0,0,0];
      prms.pt2 = [prms.dL,0,0];
      tpl = fileread(fullfile(obj.templateDir, obj.templateName()));
      geomgmsh = mp_tpl_substitute(tpl, prms);
    end
    function [maxlc] = coarsest_lc(obj)
      maxlc = max(obj.params.da, obj.params.db);
    end
  end
end
