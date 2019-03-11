%% Illustrate meshing of rectangular domain with voids
%  User specifies distribution of circular voids giving voids center and radius.
%
%%
clear variables;
%% Set meshing parameters
%
%%
meshingParams.basename ='voids_2D';
meshingParams.folder = '.';
meshingParams.dim = 2;
meshingParams.clean = false;
meshingParams.quadsonly = false;
meshingParams.lc = 0.5;

%% Setup GMSH
% This call is mandatory in order for Matlab/Octave to be able to run
% GMSH executable.
mp_setup_gmsh()

%% Generate geometric model in GMSH geo format.
%
params.lc = 0.5;

%  Define voids position and radius.
voids = [1,1, 0.2; 2,2, 0.3; 3,4, 0.5; 1, 4, 0.3];

params.xmargin = 1.0;
params.ymargin = 1.0;
params.quadsonly= true;
%
gmshgeom = mp_geom_voids2D(voids, params);

%% Generate mesh and extract node coordinates and element-nodes adjacency
%%
[nodes, elements, regions] = mp_gmsh_generate(gmshgeom, meshingParams);

%% Visualize mesh
figure(1);
clf;
mp_plot_mesh(nodes, elements);

axis('equal')
saveas(gcf(), 'voids2D.png');
% Report demo status
mp_manage_demos('report', 'voids2D', true);
