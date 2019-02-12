%% Plot labels at points 
% Put numeric label at points.
% Usage:
%  handle = mp_plot_nodes(handleOrCoords);
%  handle = mp_plot_nodes(handleOrCoords, options);
%
% Arguments:
%  handleOrCoords -- either handle to existing graphics object
%                    or N-by-2 array of coords.
%  options -- structure of options. Supported options:
%      * xOffset - fraction of X-coords span to offset lables.
%      * yOffset - fraction of Y-coords span to offset labels.
%      * labels - array of integer labels to be plotted.
%      * Color - color of the labels.
function [handles] = mp_plot_labels(handleOrCoords, varargin)
  if isgraphics(handleOrCoords)
    xyu = get(handleOrCoords, {'XData', 'YData', 'UserData'});
    x = xyu{1};
    y = xyu{2};
    ids = xyu{3};
  else
    x = handleOrCoords(:,1)';
    y = handleOrCoords(:,2)';
    ids = 1:length(x);
  end
  if nargin > 1
    color = mp_get_option(varargin{1}, 'Color', 'red');
    xOffset = mp_get_option(varargin{1}, 'xOffset', 0.0);
    yOffset = mp_get_option(varargin{1}, 'yOffset', 0.0);
    fontSize = mp_get_option(varargin{1}, 'FontSize', 10);
    relative = mp_get_option(varargin{1}, 'relative', true);
    if isfield(varargin{1}, 'labels')
      ids = varargin{1}.labels;
    end
  else
    color = 'black';
    xOffset = 0;
    yOffset = 0;
    fontSize = 10;
    relative = true;
  end
  rgbColor = rgb(color);
  s = arrayfun(@(k) {sprintf('%d',k)}, ids);
  if relative
    xf = xOffset*(max(x)-min(x));
    yf = yOffset*(max(y)-min(y));
  else
    xf = xOffset;
    yf = yOffset;
  end
  x = mean(x,1)+xf;
  y = mean(y,1)+yf;
  handles = text(x,y, s, 'Color', rgbColor, 'FontSize', fontSize, 'HorizontalAlignment', 'center');
end
