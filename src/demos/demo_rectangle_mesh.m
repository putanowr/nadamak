%% Illustrate basic mesh generation via interface to GMSH mesh generator
%
clear variables;
%% Setup GMSH
% This call is mandatory to in order for Matlab/Octave to be able to run
% GMSH executable.
mp_setup_gmsh()

%% Set meshing parameters
%
meshingParams.basename ='demo_rectangle_mesh';
meshingParams.folder = '.';
meshingParams.dim = 2;
meshingParams.clean = false;
meshingParams.quadsonly = true;

%% Generate geometric model in GMSH geo format.
gmshgeom = mp_geom_rectangle([0,0], [2,1], struct('lc', 0.15));

%% Generate mesh 
% The line below calls GMSH mesh generator and retrives generated mesh.
%  * node - array of node coordinates 
%  * elements - cell array of elements data
%  * regions - array of structures describing physical regions
[nodes, elements, regions, ~] = mp_gmsh_generate(gmshgeom, meshingParams);

%% Visualize mesh
% The simplest way to visaulize mesh obtained via mp_gmsh_generate is to 
% use mp_plot_mesh.
figure(1);
clf;
ghandles = mp_plot_mesh(gca, nodes, elements);
axis('equal')
saveas(gcf, 'demo_rectangle_mesh.png');
% Report demo status
mp_manage_demos('report', 'rectangle_mesh', true);
