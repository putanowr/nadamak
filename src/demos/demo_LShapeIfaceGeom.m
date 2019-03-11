%% Geometric model of L-Shape with interface

%% Geometric model with interface
% 
% LShapeIfaceGeom class provides geometric model with internal boundary (called interface).
% The user can set the plcement of the interface with some restricted way
% by varying parameters fA and fB in the range (0, 1).

clear variables;

%% Create Mesher object
% When Mesher object is created it takes care of initializing interface to GMSH mesh generator
mesher = mp.Mesher();

%% Create object describing geometric model
geom = mp.geoms.LShapeIfaceGeom('my_domain');
geom.params.dW = 3;
geom.params.dt = 1.2;

% Relative placement of interface endpoints.
geom.params.fA = 0.5;
geom.params.fB = 0.2;

% The mesh in the upper subdomain will consist of quad elements.
geom.params.quads = [0, 1];

%% 
% Refine the mesh around interface
geom.setInterfaceLcFactor(0.2);

%%
% <<images/LShape.png>>

%% Generate mesh
mesh = mesher.generate(geom, struct('lc', 0.6));

%% Visualize mesh
% The simplest way to visualize mesh is to use Viewer class.
viewer = mp.Viewer();

viewer.show(mesh);

%% Internal management of demo
mp_manage_demos('report', 'LShapeIfaceGeom', true);
