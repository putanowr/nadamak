classdef GeomModel < handle
  % GeomModel Represents geometric model.
  % The dim property describes the intrinsic dimension. It is 1 for curves
  % 2 for surfaces and 3 for volumes.
  % The geometric model is always treated as embedded in 3D space, that is
  % points always have 3 coordinates [x,y,z].
  % However it may happen that the geometric model is embedded is a
  % subspace of R3. If it is embeded in subspace [x,0,0] the ambientDim is
  % 1. If it is embedded in subspace [x,y,0] then ambientDim is 2.
  % In any circumstances dim <= ambientDim.
  %
  % The introduction of ambientDim is just for efficiency reason in order
  % not to condiser mapping functions that are trivially zero.
  properties(SetAccess=protected)
    dim = 0;
    ambientDim = 0;
    legacyID = 0;
    name = 'dummy';
    ntransdir = 0;
  end
  properties(Constant)
    %% Directory holding templates for geometric models.
    templateDir = fullfile(fileparts(mfilename('fullpath')), '..', '..', ...
                                      'core', 'geom', 'geomodels');
  end
  methods
    function [obj] = GeomModel(name, dim, ambientDim, legacyID)
      obj.name = name;
      obj.dim = dim;
      obj.ambientDim = ambientDim;
      obj.legacyID = legacyID;
      obj.ntransdir = dim;
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
    function [names] = regionsPerDim(obj, dim)
      % Return cell array of strings of region names of specific
      % dimension.
      prefix = {{"p_", ["b_", "i_"], ["s_", "d_"], "v_"},...
                {"p_", ["b_", "i_"], "s_", ["v_", "d_"]}};
      if nargin < 2
        names = obj.regions();
      else
        if isempty(dim) || ismissing(dim)
          names = obj.regions();
        else
          allnames = obj.regions();
          pr = prefix{obj.dim-1};
          names = allnames(startsWith(allnames, pr{dim+1}));
        end
      end
    end
  end
  methods (Abstract)
    [lc] = coarsest_lc(obj)
    [name] = templateName(obj)
    [regionNames] = regions(obj)
  end
end
