classdef SofModel < handle
  %UNTITLED Summary of this class goes here
  %   Detailed explanation goes here
  properties
    project mp.Project
    problem
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
      obj.problem.solve(progress);
      pause(1);
      status = true;
    end
  end
end

