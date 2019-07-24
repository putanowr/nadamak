classdef ParamValueBase < mp.ParametricModel
  methods (Abstract)
    [] = getValue(obj, t);
    [] = dataTable(obj);
  end
  methods
    function t=time(obj)
      t = obj.Data.gtime;
    end
    function val = value(obj)
      val = obj.getValue(obj.Data.gtime);
    end
    function plot(obj,params, ax)
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
      for i=components
         msg = sprintf('%s_%d', name, i);
         if nv > 1
           x = xy(:,1);
           y = xy(:,i+1);
         else
           x = xlim(ax);
           y = [xy(1,i+1),xy(1,i+1)];
         end  
         plot(ax, x, y, 'DisplayName', msg);
       end
      legend(ax, mp_get_option(params, 'legend', 'show'));
      hold(ax, 'off')
    end  
  end
end
