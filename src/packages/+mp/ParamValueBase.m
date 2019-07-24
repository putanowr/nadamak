classdef ParamValueBase < mp.ParametricModel
  methods (Abstract)
    [] = valueAt(obj, t);
    [] = dataTable(obj);
  end
  properties(SetAccess=immutable)
    type
  end
  methods(Sealed=true)
    function v = double(obj)
      v = obj.value();
    end
    function [dummy] = subsasgn(~,~,~)
      dummy=1;
      error('It is forbiden to modify value of Param after its created');
    end
      function p = subsref(obj,S)
      switch S(1).type
        case '()'
          p = builtin('subsref', obj.value, S);
        otherwise
          p = builtin('subsref', obj, S);
      end
    end
  end
  methods
    function obj = ParamValueBase(mytype)
      obj = obj@mp.ParametricModel();
      obj.type = mytype;
    end
    function rng = range(obj, components)
      td = obj.dataTable();
      rng = [min(td,[],1);max(td,[],1)];
      if nargin > 1
        rng = rng(:,components+1);
      end  
    end
    function t=time(obj)
      t = obj.Data.gtime;
    end
    function val = value(obj)
      val = obj.valueAt(obj.Data.gtime);
    end
    function [h] = plot(obj,params, ax)
      if nargin < 3
        figure('Name', 'Parameter Viewer');
        ax = gca;
      end
      if nargin < 2
        params = struct();
      end
      xy = obj.dataTable();
      [nv,nc] = size(xy);
      components = mp_parse_components(params, 1:nc-1);
      name = mp_get_option(params, 'name', 'v');
      hold(ax, 'on')
      h = hggroup(ax);
      for i=components
         msg = sprintf('%s_%d', name, i);
         if nv > 1
           x = xy(:,1);
           y = xy(:,i+1);
         else
           x = xlim(ax);
           y = [xy(1,i+1),xy(1,i+1)];
         end  
         plot(x, y, 'DisplayName', msg, 'Parent', h);
      end
      legend(ax, h.Children);
      hold(ax, 'off')
    end 
  end
end
