%% Illustrate how to generate quads only mesh
% 
%%
clear variables;
%% Setup GMSH
% This call is mandatory in order for Matlab/Octave to be able to run
% GMSH executable.
mp_setup_gmsh()

%% Set meshing parameters
%
%%
meshingParams.basename ='tringles_vs_quads';
meshingParams.folder = '.';
meshingParams.dim = 2;
meshingParams.clean = false;
meshingParams.quadsonly = true;

%% Generate geometric model in GMSH geo format.
%
params.lc = 0.4;
params.w = 3;
params.r = 1;
gmshgeom = mp_geom_circ_hole(params);

%% Generate quads only mesh
%
meshingParams.quadsonly = true;
[nodes, elements] = mp_gmsh_generate(gmshgeom, meshingParams);

%%
% <html><h3>Visualize mesh</h3></html>
% 
figure(1);
clf;
mp_plot_mesh(gca, nodes, elements);
axis('equal')
saveas(gcf(), 'quads_circ_hole.png');

%% Generate triangles only mesh
meshingParams.quadsonly = false;
[nodes, elements] = mp_gmsh_generate(gmshgeom, meshingParams);

%%
% <html><h3>Visualize mesh</h3></html>
% 
figure(2);
clf;
mp_plot_mesh(gca, nodes, elements); 
axis('equal')
saveas(gcf(), 'tri_circ_hole.png');
% Report demo status
mp_manage_demos('report', 'triangles_vs_quads', true);
