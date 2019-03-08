classdef Problem < handle
  % Problem Base class for various physical problems.
  properties(SetAccess=private)
    type mp.ProblemType;
    model mp.FemModel;
  end
  methods
    function [obj] = Problem(type_)
      obj.type = type_;
    end
    function setModel(obj, model_)
      disp('Setting model');
      obj.model = model_;
    end
    function solve(obj, progress)
      obj.buildMeshes(progress);
      obj.preassembly(progress);
      obj.assembly(progress)
      obj.runSolver(progress);
      obj.postprocess(progress);
    end
    function buildMeshes(obj, progress)
      progress.report(0.1, 'Building meshes');
    end
    function preassembly(obj, progress)
      progress.report(0.2, 'Do pre-assembly');
    end
    function assembly(obj, progress)
      progress.report(0.3, 'Assembly');
    end
    function runSolver(obj, progress)
      progress.report(0.6, 'Run solver');
    end
    function postprocess(obj, progress)
      progress.report(0.8, 'Postprocess');
    end  
  end
end
