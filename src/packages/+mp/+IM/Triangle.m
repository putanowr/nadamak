classdef Triangle < mp.IM.Quadrature
  methods
    function [obj] = Triangle(order)
      tag = sprintf('Triangle_%d', order);
      type = mp.IM.ImType(tag);
      [pts,w] = mp.IM.quadratureData(tag);
      obj = obj@mp.IM.Quadrature(type,pts,w);
    end
  end 
  methods 
    function [name] = getfem_name(obj)
      order = obj.type.order;
      name = sprintf('IM_TRIANG(%d)',order);
    end
  end
end
