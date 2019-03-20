%% Get tagged nodes 

%% Illustrate getting nodes on regions.
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
mesh = mesher.generate(geom, struct('lc', 0.4));

%% Create viewer
% The simplest way to visualize mesh is to use Viewer class.
viewer = mp.Viewer();

viewer.show(mesh);

selector.bottom = 1;
selector.left = 1;

bottomNodes = mp_get_tagged_region_nodes(mesh, selector, 'default');
bottomCoords = mesh.nodes(bottomNodes(:, 1), :);
opts.labels = bottomNodes(:,1);
opts.relative = false;
opts.xOffset = -0.2;
opts.yOffset = -0.1;
mp_plot_labels(gca, bottomCoords, opts);

%%
%
mp_manage_demos('report', 'mp_get_tagged_nodes', true);
