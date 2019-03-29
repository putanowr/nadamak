classdef GaussProduct2D < mp.IM.Product2D
  methods
    function [obj] = GaussProduct2D(order)
      quad = Gauss1D(order);
      obj = mp.IM.Product2D(quad, quad);
      obj.baseType = mp.IM.ImType.GaussProduct2D;
    end
  end 
  function [name] = getfem_name(obj)
    name = sprintf('IM_GAUSS_PARALLELEPIPED(2,%d)',obj.order(1));
  end
end
