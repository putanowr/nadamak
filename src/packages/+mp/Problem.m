classdef Problem < handle
  % Problem Base class for various physical problems.
  properties(SetAccess=private)
    type mp.ProblemType;
  end
  methods
    function [obj] = Problem(type_)
      obj.type = type_;
    end
  end
end
