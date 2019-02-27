%% Illustrate getting built-in meshes. 
%
% In order to test various mesh utilities without resorting to GMSH,
% one can use MeshFactory class.
% The static method MeshFactory.poduce(name) generates Mesh object.
viewer = mp.Viewer();
names = mp.MeshFactory.names();
for i=1:length(names)
  mesh = mp.MeshFactory.produce(names{i});
  viewer.show(mesh);
  viewer.labelNodes();
  viewer.labelElements();
  viewer.labelEdges();
  if i < length(names)
    viewer.stackFigure();
  end
end

% Report demo status
mp_manage_demos('report', 'MeshFactory', true);
