%% Illustrate generation of mesh in L-shape domain
%
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
% Do not echo any termian output from gmsh
meshing.showinfo = false;


%% Generate geometric model in GMSH geo format.
% The model is parameterized by the following dimensions:
%
% <<images/LShape.png>>
%
params.w = 3.0;
params.h = 5.0;
params.r = 0.2;
params.t = 0.8;
gmshgeom = mp_geom_lshape(params);

%% Generate mesh and extract node coordinates and element-nodes adjacency
%%

%%
% Set the mesh density control
meshingParams.lc = 0.4

[nodes, elements] = mp_gmsh_generate(gmshgeom, meshingParams);

%% Visualize mesh
figure(1);
clf;
mp_plot_mesh(gca, nodes, elements); 
axis('equal')
saveas(gcf(), 'lshape.png');
% Report demo status
mp_manage_demos('report', 'lshape_mesh', true);
