%% Quarter of notched rectangle geometry 

%% Illustrate properties of NotchedRQGeom geometric domain
% 

clear variables;

%% Create Mesher object
% When Mesher object is created it takes care of initializing interface to GMSH mesh generator
mesher = mp.Mesher();

%% Set meshing parameters
mesher.clean = true;
mesher.quadsonly = false;
mesher.showinfo = true;

%% Create object describing geometric model
geom = mp.geoms.NotchedRQGeom('my_domain');
geom.params.dR=0.5;
geom.params.dH=1;
%%

%% Generate mesh
mesh = mesher.generate(geom, struct('lc', 0.1));

%% Visualize mesh
% The simplest way to visualize mesh is to use Viewer class.
viewer = mp.Viewer();
viewer.show(mesh);

%%
mp_manage_demos('report', 'NotchedRQGeom', true);
