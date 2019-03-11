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
    function [names] = regionNames(obj)
      names = obj.problem.geometry.regions();
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
    function status = calculate(obj, progress)
      obj.problem.setProgressReporter(progress);
      obj.problem.solve();
      pause(1);
      status = true;
    end
    function [info] = meshInfo(obj, meshName)
      if nargin < 3
        meshName = obj.defaultMeshName;
      end
      info = obj.problem.meshInfo(meshName);
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
        mesh = mesher.generate(obj.problem.geometry, meshParams);
      catch ME
        status = false;
        msg = ME.message;
        return
      end
      msg = 'Mesh generated OK';
      status = true;
      obj.problem.registerMesh(mesh, meshName);
    end
  end
end

