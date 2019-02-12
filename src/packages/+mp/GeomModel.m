classdef GeomModel < handle
  % GeomModel Represents geometric model.
  properties(SetAccess=protected)
    dim = 0;
    legacyID = 0;
    name = 'dummy';
  end
  properties(Constant)
    %% Directory holding templates for geometric models.
    templateDir = fullfile(fileparts(mfilename('fullpath')), '..', '..', ...
                                      'core', 'geom', 'geomodels');
  end
  methods
    function [obj] = GeomModel(name, dim, legacyID)
      obj.dim = dim;
      obj.legacyID = legacyID; 
      obj.name = name;
    end
    function [geomgmsh] = as_gmsh(obj)
      tpl = fileread(fullfile(obj.templateDir, obj.templateName()));
      geomgmsh = mp_tpl_substitute(tpl, obj.params);
    end
  end 
  methods (Abstract)
    [lc] = coarsest_lc()
    [name] = templateName()
    [regionNames] = regions() 
  end
end
