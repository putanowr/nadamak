classdef SofModel < handle
  %UNTITLED Summary of this class goes here
  %   Detailed explanation goes here

  properties
    config
    geom % Geometry object
  end

  methods
    function obj = SofModel()
      %UNTITLED Construct an instance of this class
      %   Detailed explanation goes here
      obj.config = '';
    end

    function resetModel(obj)
      obj.config = '';
      obj.geom = [];
    end
    function [names] = regionNames(obj);
      names = obj.geom.regions();
    end
    function [status, msg] = setGeometricModel(obj, name)
      obj.resetModel();
      modelname='sofgeom';
      status = true;
      msg = 'Geometry object created OK';
      obj.geom = mp.GeomFactory.produce(name, modelname);
    end
    function [status, msg] = readConfig(obj,fname)
      try
        text = fileread(fname);
      catch
        status = false;
        msg = 'Reading file failed';
        return
      end
      try
        obj.config = jsondecode(text);
      catch
        status = false;
        msg = 'Decoding JSON failed';
        return
      end
      msg = 'File read corectly';
      status = true;
    end
  end
end

