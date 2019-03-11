%% Generate geometry for TwinSquares
% TwinSquares is the gometryic model of two squares sharing possibly curved
% common edge.
% 
function [outgeom] = mp_geom_twin_squares(varargin)
  mypath = mfilename('fullpath');
  [mydir,~,~] = fileparts(mypath);
  
  tpl = fileread(fullfile(mydir, 'geomodels', 'twin_squares.tpl'));
  context.lc = 0.2;
  context.w = 2;
  context.a = 0.7;
  context.curved = true;
  
  if ~isempty(varargin)
    params = varargin{1};
    if ~isstruct(params)
      error('Expecting the argument of mp_geom_twin_squares be structure with geom params')
    end
    for opt = {'lc', 'w', 'a', 'curved'}
      if isfield(params,  opt{:})
        context.(opt{:}) = params.(opt{:});
      end
    end 
  end
  outgeom = mp_tpl_substitute(tpl, context);
end
