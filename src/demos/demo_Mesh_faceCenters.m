%% Calculate and highlight face centers
%
% Get one of the predefined meshes.
mesh = mp.MeshFactory.produce('tritri');


%% Show mesh
% Show mesh
viewer = mp.Viewer();
viewer.show(mesh);

%% Face centers
%% 
centers = mesh.faceCenters();

%% Draw points at element centers
viewer.pointColor = 'cyan';
viewer.showPoints(centers);

mp_manage_demos('report', 'Mesh_faceCenters', true);
