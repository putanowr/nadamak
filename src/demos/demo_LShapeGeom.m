%% Mesh density control demo

%% Illustrate meshing LShapeGeom with various mesh densities
% 
% The LShapeGeom class provides convenient object oriented interface for
% managing L-shape geometry model.

clear variables;

%% Create Mesher object
% When Mesher object is created it takes care of initializing interface to GMSH mesh generator
mesher = mp.Mesher();

%% Set meshing parameters
mesher.basename ='demolshape';
mesher.folder = '.';
mesher.dim = 2;
mesher.clean = true;
mesher.quadsonly = false;

%% Create object describing geometric model
geom = mp.geoms.LShapeGeom('my_domain');
geom.params.dW = 3;
geom.params.dt = 1.2;
%%
% <<images/LShape.png>>

%% Generate mesh
mesh_coarse = mesher.generate(geom, struct('lc', 0.8));

%% Visualize mesh
% The simplest way to visualize mesh is to use Viewer class.
viewer = mp.Viewer();

viewer.show(mesh_coarse);
%%
% Generate and visualize mesh again.
mesh_fine = mesher.generate(geom, struct('lc', 0.2));

viewer.stackFigure();
viewer.show(mesh_fine);
%%
mp_manage_demos('report', 'LShapeGeom', true);
