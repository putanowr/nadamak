classdef GeomModel < handle
  % GeomModel Represents geometric model.
  % The dim property describes the intrinsic dimension. It is 1 for curves
  % 2 for surfaces and 3 for volumes.
  % The geometric model is always treated as embedded in 3D space, that is
  % points always have 3 coordinates [x,y,z].
  % However it may happen that the geometric model is embedded is a
  % subspace of R3. If it is embeded in subspace [x,0,0] the targetDim is
  % 1. If it is embedded in subspace [x,y,0] then targetDim is 2.
  % In any circumstances dim <= targetDim.
  %
  % The introduction of targetDim is just for efficiency reason in order
  % not to condiser mapping functions that are trivially zero.
  properties(SetAccess=protected)
    dim = 0;
    targetDim = 0;
    legacyID = 0;
    name = 'dummy';
  end
  properties(Constant)
    %% Directory holding templates for geometric models.
    templateDir = fullfile(fileparts(mfilename('fullpath')), '..', '..', ...
                                      'core', 'geom', 'geomodels');
  end
  methods
    function [obj] = GeomModel(name, dim, targetDim, legacyID)
      obj.name = name;
      obj.dim = dim;
      obj.targetDim = targetDim;
      obj.legacyID = legacyID;
    end
    function [geomgmsh] = as_gmsh(obj)
      tpl = fileread(fullfile(obj.templateDir, obj.templateName()));
      geomgmsh = mp_tpl_substitute(tpl, obj.params);
    end
    function [name] = projectName(obj)
      cln = class(obj);
      pth = split(cln, '.');
      name = mp.GeomFactory.projectName(pth{end});
    end
  end
  methods (Abstract)
    [lc] = coarsest_lc(obj)
    [name] = templateName(obj)
    [regionNames] = regions(obj)
  end
end
