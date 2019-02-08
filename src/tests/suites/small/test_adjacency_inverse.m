mp_test_register('test_adjacency_inverse', 'Test finding inverse adjacency relation')
[nodes, elements] = mp_mesh_factory('meshF');
connectivity = mp_gmsh_elems_connectivity(elements);
nodes2elems = mp_mesh_adjacency_inverse(connectivity);
s = size(nodes2elems, 1);
mp_test_assert_equal(8, s);
result = true;
for i=1:s
  n = nodes2elems{i, 1};
  for e = nodes2elems{i, 2}
    for j = size(connectivity, 1)
      if connectivity{j, 1} == e
        result = result && ismember(n, connectivity{j, 2});
        if ~result
          fprintf('failure for node %d elem %d\n', n, e); 
          fprintf('%d\n', connectivity{j,2}); 
        end
      end
    end
  end
end
mp_test_assert_equal(true, result);
