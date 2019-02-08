classdef SquareInterfaceGeom < mp.GeomModel 
  % Geometric model for SquareInterfaceGeom.
  methods
    function [obj] = SquareInterfaceGeom(name, params, legacyID)
      if nargin < 3
        legacyID = 0;
      end  
      obj = obj@mp.GeomModel(name, 2, legacyID);
    end
    function [name] = templateName(~)
      name = 'not_implemented';
    end
    function [geomgmsh] = as_gmsh(obj)
      geomgmsh = 'not mimplented';
    end
    function [maxlc] = coarsest_lc(obj)
      error('not implemented');
    end
  end
end
