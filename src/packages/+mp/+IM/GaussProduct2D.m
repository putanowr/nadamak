classdef GaussProduct2D < mp.IM.Product2D
  methods
    function [obj] = GaussProduct2D(order)
      qd = mp.IM.Gauss1D(order);
      obj = obj@mp.IM.Product2D(qd, qd);
      obj.baseType = mp.IM.ImType.GaussProduct2D;
    end
    function [name] = getfem_name(obj)
      name = sprintf('IM_GAUSS_PARALLELEPIPED(2,%d)',obj.order(1));
    end
  end
end
