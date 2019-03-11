%% Illustrate mesh generation and plotting.
%
%%
clear variables;
%% Set meshing parameters
%
%%
meshingParams.basename ='twin_squares';
meshingParams.folder = '.';
meshingParams.dim = 2;
meshingParams.clean = false;

%% Setup GMSH
% This call is mandatory in order for Matlab/Octave to be able to run
% GMSH executable.
mp_setup_gmsh()

%% Generate geometric model in GMSH geo format.
%
params.lc = 0.05;
params.w = 1;
params.r = 0.5;
% Request that thre suqres' common edge should be curve.
params.curved = true;
%
gmshgeom = mp_geom_twin_squares(params);

%% Generate mesh and extract node coordinates and element-nodes adjacency
%%
[nodes, elements, regions] = mp_gmsh_generate(gmshgeom, meshingParams);

%% Visualize mesh
figure(1);
clf;
mp_plot_mesh(gca, nodes, elements);

axis('equal')
saveas(gcf(), 'twin_squares.png');
% Report demo status
mp_manage_demos('report', 'twin_squares_mesh', true);
