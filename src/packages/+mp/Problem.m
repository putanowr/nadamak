classdef Problem < handle
  % Problem Base class for various physical problems.
  properties(SetAccess=private)
    type mp.ProblemType;
    model mp.FemModel;
    geometry;
    progress mp.Progress;
  end
  methods
    function [obj] = Problem(type_, geometry)
      obj.type = type_;
      if nargin > 1
        obj.setGeometry(geometry);
      end
      obj.progress = mp.Progress();
      obj.model = mp.FemModel();
    end
    function setProgressReporter(obj, reporter)
      obj.progress = reporter;
    end
    function setGeometry(obj, geometry)
      if ischar(geometry)
        obj.geometry = mp.GeomFactory.produce(geometry);
      else
        obj.geometry = geometry;
      end
    end
    function [info] = meshInfo(obj, meshName)
      if obj.model.meshes.hasMesh(meshName)
        mh = obj.model.meshes.get(meshName);
        nnodes = mh.nodesCount();
        nelems = mh.perDimCount(obj.geometry.dim);
        info = sprintf('Nodes: %d  Elements %d', nnodes, nelems);
      else
        info = sprintf('Error: no mesh called %s', meshName);
      end
    end
    function [mesh] = getMesh(obj, meshName)
      mesh = obj.model.meshes.get(meshName);
    end
    function registerMesh(obj, mesh, meshName)
      msg = sprintf('Registering mesh as: %s', meshName);
      obj.progress.report(obj.progress.fraction, msg);
      obj.model.meshes.register(mesh, meshName);
    end
    function solve(obj)
      obj.buildMeshes();
      obj.preassembly();
      obj.assembly()
      obj.runSolver();
      obj.postprocess();
    end
    function buildMeshes(obj)
      obj.progress.report(0.1, 'Building meshes');
    end
    function preassembly(obj)
      obj.progress.report(0.2, 'Do pre-assembly');
    end
    function assembly(obj)
      obj.progress.report(0.3, 'Assembly');
    end
    function runSolver(obj)
      obj.progress.report(0.6, 'Run solver');
    end
    function postprocess(obj)
      obj.progress.report(0.8, 'Postprocess');
    end
  end
end
