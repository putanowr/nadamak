%% Plot 2D mesh 
% TODO - finish documentation
function [handles] = mp_plot_mesh(ax, nodes, elements, varargin)
  hs = ishold(ax);
  params = struct();
  if ~isempty(varargin)
    params = varargin{1};
  end
  handles.elements = mp_plot_elements(ax, nodes, elements, params);
  showNodes = mp_get_option(params, 'showNodes', true);
  if showNodes
    hold(ax, 'on');
    handles.nodes = mp_plot_nodes(ax, nodes, params);
  end
  if ~hs
    hold(ax,'off');
  end
end