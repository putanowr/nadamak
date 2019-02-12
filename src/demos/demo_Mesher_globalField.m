%% Mesh density control demo

%% Illustrate controling mesh density via global field
% 
% RectangleGeom describes simple rectangle geometry.
% It will be meshed specifying the mesh density in three ways:
%   * using nodal lc parameters
%   * using global constant mesh size field
%   * using variable mesh size field
clear variables;

%% Create Mesher object
% When Mesher object is created it takes care of initializing interface to GMSH mesh generator
mesher = mp.Mesher();

%% Set meshing parameters
mesher.dim = 2;
mesher.clean = true;

%% Create object describing geometric model
geom = mp.geoms.RectangleGeom('my_domain');
geom.params.da = 4;
geom.params.db = 2;

%% Set factors for vertex lc parameter. 
% These factors allow mesh refinement around selected vertices
geom.params.lcFactors = [1, 0.2, 1, 1];

%% Generate mesh
meshA = mesher.generate(geom, struct('lc', 0.8));

%% Visualize mesh
% The simplest way to visualize mesh is to use Viewer class.
viewer = mp.Viewer();

viewer.show(meshA);

%% Use constant mesh density field
% Generate and visualize mesh again.
% This time we use global mesh density field

mesher.useGlobalField = true;
meshingParams.lc = 0.2;
meshingParams.globalField = 0.6;

meshB = mesher.generate(geom, meshingParams);

viewer.stackFigure();
viewer.show(meshB);

%% Use variable mesh density field
meshingParams.globalField = '0.5 - x/4*0.4';

meshC = mesher.generate(geom, meshingParams);

viewer.stackFigure();
viewer.show(meshC);

%% 
% Internal management of demos
mp_manage_demos('report', 'Mesher_globalField', true);
