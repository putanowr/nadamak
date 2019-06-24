classdef Project < handle
  % Problem Base class for various physical problems.
  properties(SetAccess=public)
    data = struct();
  end
  methods
    function [obj] = Project(fnameOrHandle)
      obj = obj@handle();
      if nargin > 0
        obj.read(fnameOrHandle)
      end
    end
  end
  methods
    function makeEmpty(obj)
      obj.data.Meta = struct();
      obj.data.Geometry = struct();
      obj.data.Mesh = struct();
      obj.data.BC = struct();
      obj.data.Material = struct();
      obj.data.Solver = struct();
    end
    function read(obj, fnameOrHandle)
      [fid, needclose] = mp_get_fid(fnameOrHandle, 'r');
      [~,~,ext] = fileparts(fopen(fid));
      if strcmp('.sof', ext)
        obj.readJSON(fid)
      else
        error('Do not know how to read project from file with extension: %s', ext);
      end
      if needclose
        fclose(fid);
      end
    end
    function readJSON(obj,fid)
      obj.data = jsondecode(fileread(fopen(fid)));
    end
    function writeJSON(obj, fid)
      fid = fopen(fid, 'w');
      fprintf(fid, jsonencode(obj.data));
      fclose(fid);
    end
    function writeFlagshyp(obj, fid)
      fid = fopen(fid, 'w');
      fprintf(fid, 'Flagshyp version of the data');
      fclose(fid);
    end
  end
end
