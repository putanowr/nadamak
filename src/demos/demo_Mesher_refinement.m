%% Illustrate uniform mesh refinement via GMSH. 
%

%% Generate mesh
%  The mesh is obtained from mesh factory using predefined meshes.
mesh = mp.MeshFactory.produce('meshA');

%% Refine mesh
% Create mesher.
mesher = mp.Mesher();

%%
% The mesh is uniformly refined two times.
refined_mesh = mesher.refine(mesh, 2);

%% Visualize meshes
viewer = mp.Viewer();
viewer.show(mesh);
viewer.stackFigure();
viewer.show(refined_mesh);

%%
% Report demo status
mp_manage_demos('report', 'Mesher_refinement', true);
