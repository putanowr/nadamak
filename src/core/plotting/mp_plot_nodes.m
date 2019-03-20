%% Plot nodes
% Put marks at points indicated by array |nodes|.
% Usage
%  handle = mp_plot_nodes(nodes);
function [handle] = mp_plot_nodes(ax, nodes, varargin)
  if isa(nodes, 'mp.SharedArray')
    if size(nodes.Data, 2) > 2
      handle = scatter3(ax, nodes.Data(:,1), nodes.Data(:,2), nodes.Data(:,3), 20, 'black','filled');
    else
       handle = scatter(ax, nodes.Data(:,1), nodes.Data(:,2), 20, 'black','filled');
    end
  else
    if size(nodes, 2) > 2
      handle = scatter3(ax, nodes(:, 1), nodes(:,2), nodes(:,3), 20, 'black', 'filled');
    else 
      handle = scatter(ax, nodes(:, 1), nodes(:,2), 20, 'black', 'filled');  
    end
  end
  set(handle, 'UserData', 1:size(nodes,1));
end
