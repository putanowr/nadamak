classdef Beam2DInterfaceGeom < mp.GeomModel 
  % Geometric model for Beam2DInterfaceGeom.
  methods
    function [obj] = Beam2DInterfaceGeom(name, params, legacyID)
      if nargin < 3
        legacyID = 0;
      end  
      obj = obj@mp.GeomModel(name, 2, legacyID);
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
