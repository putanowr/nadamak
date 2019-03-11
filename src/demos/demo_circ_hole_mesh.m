%% Illustrate mesh generation for domain with circular hole. 
%
%%
clear variables;
%% Setup GMSH
% This call is mandatory in order for Matlab/Octave to be able to run
% GMSH executable.
mp_setup_gmsh()
%% Set meshing parameters
%
meshingParams.basename ='rect';
meshingParams.folder = '.';
meshingParams.dim = 2;
meshingParams.clean = false;
%% Generate geometric model in GMSH geo format.
%
params.lc = 0.4;
params.dW = 3;
params.dr = 1;
params.lcFactors = [1,0.3,1,1,1,1,1,1];
gmshgeom = mp_geom_circ_hole(params);
%% Generate mesh
%
[nodes, elements] = mp_gmsh_generate(gmshgeom, meshingParams);
%% Visualize mesh
%
figure(1);
clf;
mp_plot_mesh(nodes, elements);
axis('equal')
saveas(gcf(), 'circ_hole.png');
% Register demo status
mp_manage_demos('report', 'circ_hole_mesh', true);