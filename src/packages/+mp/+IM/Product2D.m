classdef Product2D < mp.IM.Quadrature
  properties(SetAccess=private)
    typePerDim
    orderPerDim
    names
  end
  methods
    function [obj] = Product2D(qdX, qdY)
      xpts = qdX.pts(:,1);
      ypts = qdY.pts(:,1);
      [xx,yy] = meshgrid(xpts, ypts);
      [wx,wy] = meshgrid(qdX.w, qdY.w);
      xx=xx';
      yy=yy';
      pts = [xx(:), yy(:)];
      w = (wx.*wy)'; 
      w = w(:);
      obj = obj@mp.IM.Quadrature(mp.IM.ImType.Product2D,pts,w);
      obj.typePerDim = {qdX.type, qdY.type};
      obj.orderPerDim = [qdX.order(), qdY.order()];
      obj.names = {qdX.getfem_name(),qdY.getfem_name()};
    end
    function [n] = order(obj, varargin)
      if isempty(varargin)
        n = sum(obj.orderPerDim);
      else
        n = obj.orderPerDim(varargin{1});
      end
    end
    function [t] = type(obj, varargin)
      if isempty(varargin)
        t = obj.baseType;
      else
        t = obj.typePerDim{varargin{1}};
      end
    end
    function [name] = getfem_name(obj)
      name = sprintf('IM_PRODUCT(%s, %s)',obj.names{1}, obj.names{2});
    end
  end
end
