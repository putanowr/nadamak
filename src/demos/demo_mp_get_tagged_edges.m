%% Get tagged edges 

%% Illustrate getting edges on region using function mp_get_tagged_region_edges.
% This function returns indices and tags of mesh edges that are incident to
% the regions specified.
% 
clear variables;

%% Create object describing geometric model
geom = mp.geoms.LShapeGeom('my_domain');
geom.params.dW = 3;
geom.params.dt = 1.2;
%%
% <<images/tmp_LShape.png>>

%% Generate mesh
mesher = mp.Mesher();
mesh = mesher.generate(geom, struct('lc', 0.8));

%% Create viewer
% The simplest way to visualize mesh is to use Viewer class.
viewer = mp.Viewer();

viewer.show(mesh);

%% Create edges selector
% The LShapeGeom geometric model distinguishes boundary endges as well
% as their subsets. Here we prepare selector that will assign tag 0 to
% boundary edges, and tags 1 and 2 respectively to 'bottom' left' set.
selector.bottom = 1;
selector.left = 2;
selector.boundary = 0;

%% Get tagged edges
taggedEdges = mp_get_tagged_region_edges(mesh, selector, 'default');

%% Visualize tagged edges
% In the code below we draw each tagged edge with collo dependint on its
% tag

% This adjacency table is needed to get edge enpoints coordinates.
e2v = mesh.getAdjacency(1, 0);

colors = {'red', 'yello', 'blue'};

%%
% The handles array will hold tree elements that are lines belonging
% 'boundary', 'bottom' and 'left' regions. This is in order to easily
% create picture legend.
handles =[];

%%
% Iterate over all taggede edged and plot them.
for i = 1:size(taggedEdges,1)
  edge = taggedEdges(i, 1);
  label = taggedEdges(i, 2)+1;
  xy = mesh.nodes(e2v.at(edge), :);
  lh = line(xy(:, 1), xy(:, 2), 'Color', colors{label}, 'LineWidth', 2);
  handles(label) = lh;
end
lgd = legend(handles,{'0: boundary','1: bottom','2: left'});
title(lgd, 'Edge regions');

%%
%
mp_manage_demos('report', 'mp_get_tagged_edges', true);
