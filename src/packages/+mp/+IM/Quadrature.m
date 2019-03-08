classdef Quadrature < handle
  % Numerical quadrature.
  properties(SetAccess=protected)
    type mp.IM.ImType 
    pts
    w
  end
  methods
    function [obj] = Quadrature(type,pts,w)
      obj.type = type;
      obj.pts = pts;
      obj.w = w;
    end
  end 
  methods (Abstract)
    [name] = getfem_name() 
  end
end
