classdef Quadrature < handle
  % Numerical quadrature.
  properties(SetAccess=protected)
    baseType mp.IM.ImType
    pts
    w
  end
  methods
    function [obj] = Quadrature(type,pts,w)
      obj.baseType = type;
      obj.pts = pts;
      obj.w = w;
    end
    function [n] = numOfPoints(obj)
      n = numel(obj.w);
    end
    function [t]= type(obj)
      t = obj.baseType;
    end
    function [n] = order(obj)
      if obj.baseType.order > 0
        n = obj.baseType.order;
      else
        error('Internal error: missing order method for %s', obj.baseType);
      end
    end
  end
  methods (Abstract)
    [name] = getfem_name(obj);
  end
end
