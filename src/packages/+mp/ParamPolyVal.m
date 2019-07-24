classdef ParamPolyVal < mp.ParamValueBase
  properties (Access = private)
    xv
  end
  methods
    function obj=ParamPolyVal(x,v)
      obj = obj@mp.ParamValueBase();
      if isrow(x)
        x = x(:);
      end
      if isrow(v)
        v = v(:);
      end
      obj.xv = [x,v];
    end
    function val = getValue(obj, t)
      if t < obj.xv(1,1)
        val = obj.xv(1,2:end);
      elseif t > obj.xv(end,1)
        val = obj.xv(end,2:end);
      else        
        val = interp1(obj.xv(:,1),obj.xv(:,2:end),t);
      end  
    end
    function td = dataTable(obj,components)
      if nargin < 2
        td = obj.xv;
      else
        td = obj.xv(:,components+1);
      end
    end
    function rng = range(obj, components)
      rng = [min(obj.xv);max(obj.xv)];
      if nargin > 1
        rng = rng(:,components+1);
      end
    end  
  end
end 
