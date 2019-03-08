classdef SofModel < handle
  %UNTITLED Summary of this class goes here
  %   Detailed explanation goes here
  properties
    project mp.Project
    model   mp.FemModel
  end

  methods
    function obj = SofModel()
      %UNTITLED Construct an instance of this class
      %   Detailed explanation goes here
      obj.resetModel();
    end
    function resetModel(obj)
      obj.project = mp.Project();
      obj.model = mp.FemModel('square', 'mechanical');
    end
    function [names] = regionNames(obj)
      names = obj.model.geometry.regions();
    end
    function [status, msg] = setModel(obj, geomName, problemName)
      status = true;
      msg = 'Geometry object created OK';
      try
        obj.model = mp.FemModel(geomName, problemName);
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
      disp(obj.model);
      disp(obj.model.problem);
      obj.model.problem.solve(progress);
      pause(1);
      status = true;
    end
  end
end

