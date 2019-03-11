%% Illustrate numbering of edges in triangular elements. 
%
% In order to test various mesh utilities without resorting to GMSH,
% one can use MeshFactory class.
% The static method MeshFactory.poduce(name) generates Mesh object.
viewer = mp.Viewer();

mesh = mp.MeshFactory.produce('meshA');
viewer.show(mesh);
viewer.labelNodes()
viewer.labelElements();
viewer.labelEdges();

f2v = mesh.getAdjacency(2,0);
e2v = mesh.getAdjacency(1,0);
f2e = mesh.getAdjacency(2,1);

%% Faces to vertices relation
%
for i=1:f2v.length;
  fprintf('Element %d nodes : ', i);
  nodes = f2v.at(i);
  fprintf(' %d', nodes);
  fprintf('\n');
end

%% Edges to vertices relation
%
for i=1:e2v.length;
  fprintf('Edge %d nodes : ', i);
  nodes = e2v.at(i);
  fprintf(' %d', nodes);
  fprintf('\n');
end

%% Faces to edges relation
%
for i=1:f2e.length;
  fprintf('Element %d edges : ', i);
  edges = f2e.at(i);
  fprintf(' %d', edges);
  fprintf('\n');
end

%% Tags of edges in faces
%
[edgeTags, ~, ~] = mp_face_edge_data(mesh);
disp(edgeTags.Data)

%%
% Report demo status
mp_manage_demos('report', 'edges_in_triangles', true);

