function [outgeom] = mp_geom_part_circle(center, radius, varargin)
  mypath = mfilename('fullpath');
  [mydir,myname,myext] = fileparts(mypath);
  
  tpl = fileread(fullfile(mydir, 'geomodels', 'circle_part.tpl'));
  context.lc = 1.0;
  
  if length(varargin) > 0
    params = varargin{1};
    if ~isstruct(params)
      error('Expecting third argument of mp_geom_rectangle be structure with geom params')
    end
    for opt = {'lc','partname'}
      if isfield(params,  opt{:})
        context.(opt{:}) = params.(opt{:});
      end
    end 
  end
  context.x = center(1);
  context.y = center(2);
  context.R = radius;
  outgeom = mp_tpl_substitute(tpl, context);
end
