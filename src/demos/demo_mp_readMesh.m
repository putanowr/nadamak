%% Illustrate reading file into Mesh object.
%
clear variables;
%% Access test data file.
% The call below uses data file stored in tests/data folder.
% Because we want to use test data files we have to initialize tests
% in order to be able to find the files.
mp_test_initialize();
% Open test data file for reading a mesh.
fhandle = mp_test_data_fopen('rectangle_with_regions.msh');
mesh = mp.readMesh(fhandle);

%% Visualize mesh
% Use Viewer object.
viewer = mp.Viewer();
viewer.show(mesh);
% Report demo status
mp_manage_demos('report', 'mp_readMesh', true);