classdef CubeGeom < mp.GeomModel
  % Geometric model for CubeGeom.
  properties (Access=public)
    params = struct();
  end
  methods
    function [obj] = CubeGeom(name, params, legacyID)
      if nargin < 3
        legacyID = 0;
      end
      obj = obj@mp.GeomModel(name, 3, 3, legacyID);
    end
    function [name] = templateName(~)
      name = 'cube.tpl';
    end
    function [geomgmsh] = as_gmsh(obj)
      tpl = fileread(fullfile(obj.templateDir, obj.templateName()));
      geomgmsh = mp_tpl_substitute(tpl, obj.params);
    end
    function [maxlc] = coarsest_lc(obj)
      maxlc = 1.0;
    end
    function [regionNames] = regions(~)
      regionNames = {'d_cube', 'b_top', 'b_bottom', 'b_left', 'b_right', 'b_front', 'b_back'};
    end
  end
end
