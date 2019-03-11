%% Geometric model of a sauare with circular hole

clear variables;

%% Create Mesher object
% When Mesher object is created it takes care of initializing interface to GMSH mesh generator
mesher = mp.Mesher();

%% Create object describing geometric model
geom = mp.geoms.SquareHoleGeom('my_domain');
geom.params.dW = 3;
geom.params.dr = 0.8;

%%
% Set meshing factor to refine region at SE corner.
geom.params.lcFactors = [1, 0.3, 1, 1];

%% Generate mesh
mesh = mesher.generate(geom, struct('lc', 0.6));


%% Region names

regionNames = mesh.regionNames;
for i = 1:length(regionNames)
  fprintf('Region:  %s\n', regionNames{i});
end

%% Visualize mesh
% The simplest way to visualize mesh is to use Viewer class.
viewer = mp.Viewer();

viewer.show(mesh);

%% Internal management of demo
mp_manage_demos('report', 'SquareHoleGeom', true);

