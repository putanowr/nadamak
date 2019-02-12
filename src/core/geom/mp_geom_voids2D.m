function [outgeom] = mp_geom_voids2D(data, varargin)
  %% Generate geometric model for an rectangular region with circular voids.
  %  Parameters:
  %    data - N by 3 array giving for each void [x,y,R]
  %  Optional parameters
  %    xmargin - distance from vertical boundaries to the voids
  %    ymargin - distance fro horizontal boundaries to the voids
  context.lc = 1.0;
  context.xmargin = 1.0;
  context.ymargin = 1.0;
  context.quadsonly = true;
  
  if length(varargin) > 0
    params = varargin{1};
    if ~isstruct(params)
      error('Expecting third argument of mp_geom_rectangle be structure with geom params')
    end
    for opt = {'lc', 'xmargin', 'ymargin', 'quadsonly'}
      if isfield(params,  opt{:})
        context.(opt{:}) = params.(opt{:});
      end
    end 
  end

  tpl = mp_geom_part_preamble(context);
  for i=1:size(data, 1)
    partname = sprintf('circ%d',i);
    tpl = [tpl,  mp_geom_part_circle(data(i,1:2), data(i,3), struct('partname', partname))];
  end
 
  if ~isempty(data)
    xmin = min(data(:, 1)) - context.xmargin;
    ymin = min(data(:, 2)) - context.ymargin;
    xmax = max(data(:, 1)) + context.ymargin;
    ymax = max(data(:, 2)) + context.ymargin;
  else
    xmin =  - context.xmargin;
    ymin =  - context.ymargin;
    xmax =  context.ymargin;
    ymax =  context.ymargin; 
  end
  
  tpl = [tpl,  mp_geom_part_rectangle([xmin, ymin], [xmax, ymax], context)];
  
  ninc = size(data,1);
  nnlmax = 5*ninc;
  if ninc > 1
    surftpl = sprintf('Plane Surface(news) = { _nll, LinSpace[-5, -(%d), %d] };', nnlmax, ninc);
  elseif ninc == 1
    surftpl = sprintf('Plane Surface(news) = { _nll, -5 };');
  else
    surftpl = sprintf('Plane Surface(news) = { _nll };');
  end 
  tpl = [tpl, surftpl];
  surftpl = sprintf('\nPhysical Surface("rect") = { news-1};');
  tpl = [tpl, surftpl];
  
  outgeom = mp_tpl_substitute(tpl, context);
end
