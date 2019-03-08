classdef FemModel < handle
  % FemModel Is the main data structure on which the Kernel of Nadamak simulator works.
  properties(SetAccess=private)
    geometry;
    problem;
    meshes = mp.MeshRegistry();
  end
  methods
    function [obj] = FemModel(geometry, problem)
      obj.geometry = geometry;
      obj.problem = problem;
    end
    function resolveGeometry(obj)
      % Create the coarse mesh of geometry just to access
      % geometric model properties such as vertices, regions, etc.
      if ~obj.meshes.hasMesh('geomcoarse')
        maxlp = obj.geometry.coarsest_lc();
        param = struct('lc', maxlp);
        geomgmsh = mp_tpl_substitute(obj.geometry.as_gmsh(), param);
        dim = obj.geometry.dim;
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
