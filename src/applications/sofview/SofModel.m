classdef SofModel < handle
  %UNTITLED Summary of this class goes here
  %   Detailed explanation goes here
  properties
    project mp.Project
    problem
  end
  properties(Constant)
    defaultMeshName = 'mainmesh';
  end
  methods
    function obj = SofModel()
      %UNTITLED Construct an instance of this class
      %   Detailed explanation goes here
      obj.resetModel();
    end
    function resetModel(obj)
      obj.project = mp.Project();
      obj.problem = mp.ProblemFactory.produce('mechanical', ...
                    struct('geometry', 'square'));
    end
    function [dim] = geometryDim(obj)
      dim = obj.problem.geometry.dim();
    end
    function [names] = regionNames(obj, dim)
      % Return names of regions of given dimension.
      % This function returns cell array of strings.
      % 
      % Arguments:
      %   * dim (optional) - region dimension. If not
      %                      given then returns names of
      %                      regions of dimension equal
      %                      the dimension of geometric model.
      if nargin < 2
        dim = obj.geometryDim();
      end
      names = obj.problem.geometry.regionsPerDim(dim);
    en%d
    function writeBc(obj, fid)
      obj.problem.writeBc(fid);
    end
    function writeDofs(obj, fid)
      obj.problem.writeDofs(fid)
    end  
    function [status, msg, bc] = setBc(obj, regionName, variableName, bcName, params)
      status = true;
      msg = sprintf('Set BC on "%s" to "%s"', regionName, bcName);
      bc = mp.BcFactory.produce(bcName, variableName, params);
      obj.problem.setBc(regionName, bc);
    end
    function [bc] = getBc(obj, regionName, variableName)
      bc = [];
      if obj.problem.hasBc(regionName, variableName)
        bc = obj.problem.getBc(regionName, variableName);
      end
    end
    function [bcName] = getBcName(obj, regionName, variableName)
      type = mp.BcType.NotSet;
      if obj.problem.hasBc(regionName, variableName)
        bc = obj.problem.getBc(regionName, variableName);
        type = bc.type;
      end
      bcName = char(type);
    end
    function [status, msg] = setProblem(obj, problemName, geomName)
      status = true;
      msg = 'Geometry object created OK';
      try
        obj.problem = mp.ProblemFactory.produce(problemName, ...
                      struct('geometry', geomName));
      catch ME
        status = false;
        msg = ME.message;
      end
    end
    function [status, msg] = readConfig(obj,fname)
      try
        obj.project.read(fname)
      catch
        status = false;
        msg = 'Reading file failed';
        return
      end
      msg = 'File read corectly';
      status = true;
    end
    function status = calculate(obj, progress, options)
      obj.problem.setProgressReporter(progress);
      obj.problem.solve(options);
      pause(1);
      status = true;
    end
    function [info] = meshInfo(obj, meshName)
      if nargin < 3
        meshName = obj.defaultMeshName;
      end
      info = obj.problem.meshInfo(meshName);
    end
    function [mesh] = getMesh(obj, meshName)
      if nargin < 2
        meshName = obj.defaultMeshName;
      end
      mesh = obj.problem.getMesh(meshName);
    end
    function status = hasMesh(obj)
      status = obj.problem.hasMesh();
    end
    function [d] = getNodalDisplacement(obj)
       varName = 'Displacement';
       if obj.problem.model.variables.hasVariable(varName)
         var = obj.problem.model.variables.get(varName);
         nnodes = var.fem.mesh.countNodes();
         val = var.dofValues(var.fem.nodes2dofs);
         d = reshape(val, var.variable.qdim, nnodes)';
       else
         d = [];
       end
    end
    function [status, msg] = generateMesh(obj, meshParams, meshName)
      % For the geometry stored in FemModel generate mesh
      % and store it under given name. If name is not given
      % 'mainmesh' is used.
      if nargin < 3
        meshName = obj.defaultMeshName;
      end
      mesher = mp.Mesher();
      try
        meshParams.dim = obj.problem.geometry.dim;
        mesh = mesher.generate(obj.problem.geometry, meshParams);
        mp_log('SofModel created Mesh of dimension %d', mesh.dim);
      catch ME
        status = false;
        msg = ME.message;
        return
      end
      msg = 'Mesh generated OK';
      status = true;
      obj.problem.registerMesh(mesh, meshName);
    end
    function buildProject(obj)
      obj.project = mp.Project();
      obj.problem.exportToProject(obj.project);
    end
    function [status, msg] = export(obj, format, fpath)
      [status, msg] = obj.problem.export(format, fpath);
    end
    function [materialName] = getRegionMaterial(obj, regionName)
      materialName = 'default';
    end
  end
end

