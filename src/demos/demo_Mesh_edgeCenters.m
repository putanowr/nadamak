%% Calculate and highlight edge centers
%

%%
% Get one of the predefined meshes.
mesh = mp.MeshFactory.produce('tritri');

%% Show mesh
% Show mesh
viewer = mp.Viewer();
viewer.show(mesh);

%% Edge centers
%% 
centers = mesh.edgeCenters();

%% Draw points at element centers
viewer.pointColor = 'red';
viewer.showPointsXY(centers(:,1), centers(:, 2));

%%
% 
mp_manage_demos('report', 'Mesh_edgeCenters', true);
