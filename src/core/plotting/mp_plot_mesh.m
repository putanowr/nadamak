%% Plot 2D mesh 
% TODO - finish documentation
function [handles] = mp_plot_mesh(nodes, elements, varargin)
  hs = ishold();
  params = struct();
  if ~isempty(varargin)
    params = varargin{1};
  end
  handles.elements = mp_plot_elements(nodes, elements, params);
  showNodes = mp_get_option(params, 'showNodes', true);
  if showNodes
    hold on
    handles.nodes = mp_plot_nodes(nodes, params);
  end
  if ~hs
    hold off;
  end
end