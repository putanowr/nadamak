function [outgeom] = mp_geom_rectangle(pointA, pointB, varargin)
  mypath = mfilename('fullpath');
  [mydir,~,~] = fileparts(mypath);
  
  tpl = fileread(fullfile(mydir, 'geomodels', 'rectangle.tpl'));
  context = struct();
  
  if ~isempty(varargin)
    params = varargin{1};
    if ~isstruct(params)
      error('Expecting third argument of mp_geom_rectangle be structure with geom params')
    end
    context.lcFactors = [1,1,1,1];
    for opt = {'lc', 'partname', 'lcFactors'}
      if isfield(params,  opt{:})
        context.(opt{:}) = params.(opt{:});
      end
    end 
  end
  context.pt1 = [pointA(1:2), 0.0];
  context.pt2 = [pointB(1), pointA(2), 0.0];
  context.pt3 = [pointB(1:2), 0.0];
  context.pt4 = [pointA(1), pointB(2), 0.0];
  outgeom = mp_tpl_substitute(tpl, context);
end
