classdef Project < handle
  % Problem Base class for various physical problems.
  properties(SetAccess=public)
    data = struct();
  end
  methods
    function [obj] = Project(fnameOrHandle)
      obj = obj@handle();
      obj.read(fnameOrHandle)
    end
  end
  methods
    function read(obj, fnameOrHandle)
      [fid, needclose] = mp_get_fid(fnameOrHandle, 'r');
      [~,~,ext] = fileparts(fopen(fid));
      if strcmp('.cmb', ext)
        obj.readJSON(fid)
      else
        error('Do not know how to read project from file with extension: %s', ext);
      end
      if needclose
        fclose(fid);
      end
    end
    function readJSON(self,fid)
      self.data = jsondecode(fileread(fopen(fid)));
    end    
  end
end
