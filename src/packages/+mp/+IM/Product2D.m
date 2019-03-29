classdef Product2D < mp.IM.Quadrature
  properties(SetAccess=private)
    typePerDim
    orderPerDim
    names
  end
  methods
    function [obj] = Product2D(quadX, quadY)
      type = mp.IM.ImType.Product2D;
      typePerDim(1) = quadX.type;
      typePerDim(2) = quadY.type;
      orderPerDim(1) = quadX.order();
      orderPerDim(2) = quadY.order();
      xpts = quadX.pts(:,1);
      ypts = quadY.pts(:,1);
      [xx,yy] = meshgrid(xpts, ypts);
      [wx,wy] = meshgrid(quadX.w, quadY.w);
      xx=xx';
      yy=yy';
      pts = [xx(:), yy(:)];
      w = (wx.*wy)'; 
      obj = obj@mp.IM.Quadrature(type,pts,w);
      obj.names = {quadX.getfem_name(),quadY.getfem_name()};
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
        t = obj.typePeDim(varargin{1});
      end
    end
  end 
  methods 
    function [name] = getfem_name(obj)
      name = sprintf('IM_PRODUCT(%s, %s),obj.names{1}, obj.names{2});
    end
  end
end
