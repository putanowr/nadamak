classdef Gauss1D < mp.IM.Quadrature
  methods
    function [obj] = Gauss1D(order)
      if rem(order,2) == 0
        order = order+1;
      end
      tag = sprintf('Gauss1D_%d', order);
      type = mp.IM.ImType(tag);
      [pts,w] = mp.IM.quadratureData(tag);
      obj = obj@mp.IM.Quadrature(type,pts,w);
    end
  end 
  methods 
    function [name] = getfem_name(obj)
      order = obj.type.order;
      name = sprintf('IM_GAUSS1D(%d)',order);
    end
  end
end
