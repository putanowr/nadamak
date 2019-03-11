function [outgeom] = mp_geom_circ_hole(varargin)
  mypath = mfilename('fullpath');
  [mydir,~,~] = fileparts(mypath);
  
  tpl = fileread(fullfile(mydir, 'geomodels', 'circ_hole.tpl'));
  context.lc = 0.4;
  context.dW = 3;
  context.dr = 1;
  context.lcFactors = [1,1,1,1,1,1,1,1];
  
  if ~isempty(varargin)
    params = varargin{1};
    if ~isstruct(params)
      error('Expecting the argument of mp_circ_hole_geom be structure with geom params')
    end
    for opt = {'lc', 'dW', 'dr', 'lcFactors'}
      if isfield(params,  opt{:})
        context.(opt{:}) = params.(opt{:});
      end
    end 
  end
  outgeom = mp_tpl_substitute(tpl, context);
end
