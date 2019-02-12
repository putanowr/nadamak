function [outgeom] = mp_geom_lshape(varargin)
  mypath = mfilename('fullpath');
  [mydir,~,~] = fileparts(mypath);
  
  tpl = fileread(fullfile(mydir, 'geomodels', 'lshape.tpl'));
  context.dW = 3;
  context.dH = 5;
  context.dr = 0.2;
  context.dt = 0.8;
  context.lcFactors = ones(1,12);
  
  if ~isempty(varargin)
    params = varargin{1};
    if ~isstruct(params)
      error('Expecting the argument of mp_geom_lshape be structure with geom params')
    end
    for opt = {'dH', 'dr', 'dt', 'dW', 'lcFactors'}
      if isfield(params,  opt{:})
        context.(opt{:}) = params.(opt{:});
      end
    end 
  end
  outgeom = mp_tpl_substitute(tpl, context);
end
