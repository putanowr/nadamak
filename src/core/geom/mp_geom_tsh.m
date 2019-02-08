%% Generate geometry for TSH
% TSH is a geometric model similar to TwinSquares but with two additional
% circular voids or inclusions
% 
function [outgeom] = mp_geom_tsh(varargin)
  mypath = mfilename('fullpath');
  [mydir,~,~] = fileparts(mypath);
  
  tpl = fileread(fullfile(mydir, 'geomodels', 'tsh.tpl'));
  context.dW = 2.0;
  context.dH = 1.0;
  context.dbottom = context.dW*0.5;
  context.dtop = context.dW*0.75;
  context.dmx = context.dW*0.5;
  context.dmy = context.dH*0.5;
  context.curved = true;
  context.insets = [0, 0];
  context.insets_x = [0, 0];
  context.insets_y = [0, 0];
  context.insets_R = [0, 0];
  context.insets_N = [3, 3];
  context.quads = [0, 0];
  context.nxelems = [5, 5];
  context.nyelems = 5;
  context.structured = [0, 0];
  
  if ~isempty(varargin)
    params = varargin{1};
    if ~isstruct(params) && ~isobject(params)
      error('Expecting the argument of mp_geom_tsh be structure with geom params')
    end
    for opt = {'dW', 'dH', 'dbootom', 'dtop', 'dmx', 'dmy', 'curved', 'insets', ...
               'insets_x', 'insets_y', 'insets_R', 'insets_N', 'quads', 'nxelems', 'nyelems', ...
               'structured'}
      if (isstruct(params) && isfield(params,  opt{:}))|| (isobject(params) && isprop(params, opt{:}))
        context.(opt{:}) = params.(opt{:});
      end
    end 
  end
  outgeom = mp_tpl_substitute(tpl, context);
end
