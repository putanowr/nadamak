%% Triangular higher order elements 

% 
clear variables;

%% Create Mesher object
% When Mesher object is created it takes care of initializing interface to GMSH mesh generator
mesher = mp.Mesher();

%% Create object describing geometric model
geom = mp.geoms.TriangleGeom('my_domain');
lc = geom.coarsest_lc();

%% Generate mesh
mesh = mesher.generate(geom, struct('lc', lc, 'order', 2));

%% Visualize mesh
% The simplest way to visualize mesh is to use Viewer class.
viewer = mp.Viewer();

viewer.show(mesh);
viewer.labelNodes(struct('xOffset',0.03, 'yOffset', 0.03));
%%
mp_manage_demos('report', 'TriangleHighOrder', true);
