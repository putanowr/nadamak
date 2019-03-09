classdef FemModel < handle
  % FemModel Is the main data structure on which the Kernel of Nadamak simulator works.
  properties(SetAccess=private)
    meshes = mp.MeshRegistry();
  end
  methods
    function [obj] = FemModel()
    end
    function resolveGeometry(obj, geometry)
      % Create the coarse mesh of geometry just to access
      % geometric model properties such as vertices, regions, etc.
      if ~obj.meshes.hasMesh('geomcoarse')
        maxlp = geometry.coarsest_lc();
        param = struct('lc', maxlp);
        geomgmsh = mp_tpl_substitute(geometry.as_gmsh(), param);
        dim = geometry.dim;
        meshingParam.dim = dim;
        meshingParam.basename = '__geomcoarse';
        meshingParam.clean = true;
        [n,e,r,m] = mp_gmsh_generate(geomgmsh, meshingParam);
        mesh = mp.Mesh(dim, n,e,r,m);
        obj.meshes.register(mesh, 'geomcoarse')
      end
    end
  end
end
