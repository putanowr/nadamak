classdef Problem < handle
  % Problem Base class for various physical problems.
  properties(SetAccess=private)
    legacyID = 0;
  end
  methods
    function [obj] = Problem(legacyID)
      obj.legacyID = 0; 
    end
  end
end
