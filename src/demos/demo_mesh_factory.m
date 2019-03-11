%% Illustrate getting built-in meshes. 
%
% In order to test various mesh utilities without resorting to GMSH,
% one can use function mp_mesh_factory().
% The function is a factory for mesh node coordinates and elements connectivity.
% Nodes and elements are returned in the same format as they are returned by
% function mp_gmsh_mesh_generate().

mesh_names = {'meshA', 'meshB', 'meshC', 'meshD', 'meshE', 'meshF',...
              'square1', 'square9', 'triangle1', 'tritri'};

for i=1:length(mesh_names)
  name = mesh_names{i};
  [nodes, elements] = mp_mesh_factory(name);
  figure(i)
  clf;
  title(name);
  mp_plot_mesh(gca, nodes, elements);
  axis('equal')
  figname = [name, '.png'];
  saveas(gcf, figname);
end
% Report demo status
mp_manage_demos('report', 'mesh_factory', true);
