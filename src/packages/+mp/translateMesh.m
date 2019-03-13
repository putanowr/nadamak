function translateMesh(mesh, displacement)
  % Translate mesh by given displacement vector.
  for i=1:length(displacement)
    mesh.nodes(:,i) = mesh.nodes(:,i)+displacement(i);
  end  
end
