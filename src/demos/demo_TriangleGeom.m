%% Triangular domain demo

%% Illustrate meshing TriangleGeom with various mesh densities
% 
clear variables;

%% Create Mesher object
% When Mesher object is created it takes care of initializing interface to GMSH mesh generator
mesher = mp.Mesher();

%% Create object describing geometric model
geom = mp.geoms.TriangleGeom('my_domain');
lc = geom.coarsest_lc();

%% Generate mesh
mesh_coarse = mesher.generate(geom, struct('lc', lc));

%% Visualize mesh
% The simplest way to visualize mesh is to use Viewer class.
viewer = mp.Viewer();

viewer.show(mesh_coarse);
%%
% Generate and visualize mesh again.
mesh_fine = mesher.generate(geom, struct('lc', lc/4));

viewer.stackFigure();
viewer.show(mesh_fine);
%%
mp_manage_demos('report', 'TriangleGeom', true);
