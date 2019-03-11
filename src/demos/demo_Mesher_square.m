%% Illustrate mesh generation using object oriented interface
%
clear variables;
%% Crete Mesher object
% When Mesher object is created it takes care of initializing interface to GMSH mesh generator
mesher = mp.Mesher();

%% Set meshing parameters
mesher.basename ='demosquaremesh';
mesher.folder = '.';
mesher.dim = 2;
mesher.clean = false;
mesher.quadsonly = false;

%% Create object describing geometric model to be meshed
geom = mp.geoms.SquareGeom('my_domain', struct('da', 2.0));

% Refine mesh around SE corner by setting lc factor to 0.5
geom.params.lcFactors = [1,0.2,1,1];

%% Generate geometric model in GMSH geo format.
gmshgeom = mp_geom_rectangle([0,0], [2,1], struct('lc', 0.15));

%% Generate Mesh object

mesh = mesher.generate(geom, struct('lc', 0.5));

%% Visualize mesh
% The simplest way to visaulize mp_plot_mesh.
figure(1);
clf;
ghandles = mp_plot_mesh(mesh.nodes, mesh.elements);
axis('equal')
saveas(gcf, 'demo_square_mesh.png');
% Report demo status
mp_manage_demos('report', 'Mesher_square', true);
