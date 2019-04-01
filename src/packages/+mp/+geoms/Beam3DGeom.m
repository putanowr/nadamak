classdef Beam3DGeom < mp.GeomModel 
  % Geometric model for Beam3DGeom.
  methods
    function [obj] = Beam3DGeom(name, params, legacyID)
      if nargin < 3
        legacyID = 0;
      end  
      obj = obj@mp.GeomModel(name, 1, 3, legacyID);
    end
    function [name] = templateName(~)
      name = 'not_implemented.tpl';
    end
    function [geomgmsh] = as_gmsh(obj)
      geomgmsh = 'not mimplented';
    end
    function [maxlc] = coarsest_lc(obj)
      error('not implemented');
    end
    function [regionNames] = regions(~)
      error('not implemented yet');
    end
  end
end
