classdef FemModel < handle
  % FemModel Is the main data structure on which the Kernel of Nadamak simulator works.
  properties(SetAccess=private)
    meshes mp.MeshRegistry;
    fems struct; % structure holding name -> MeshFem.
    variables mp.ModelVariableRegistry;
  end
  properties
    K
    F
  end
  methods
    function [obj] = FemModel()
      obj.meshes = mp.MeshRegistry;
      obj.fems = struct();
      obj.variables = mp.ModelVariableRegistry();
      K = [];
      F = [];
    end
    function resetVariables(obj)
      obj.variables = mp.ModelVariableRegistry();
    end
    function [fem] = addFem(obj, name, meshName, regionName, femType, qdim)
      mesh = obj.meshes.get(meshName);
      fem = mp.MeshFem(mesh, regionName, femType, qdim);
      obj.fems.(name) = fem;
    end
    function fem = getFem(obj, name)
      fem = obj.fems.(name);
    end
    function [fem] = addIsoparametricFem(obj, name, meshName, qdim)
      mesh = obj.meshes.get(meshName);
      femType = mesh.geomTrans.fem;
      regionName = 'all';
      fem = obj.addFem(name, meshName, regionName, femType, qdim);
    end
    function n = numOfDofs(obj)
      n = obj.variables.offset;
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
    function writeDofs(obj, fid)
      for name = obj.variables.names()
        fprintf(fid, 'Dofs for %s\n', name{:});
        var = obj.variables.get(name{:});
        var.fem.writeDofs(fid);
      end
    end
  end
end
