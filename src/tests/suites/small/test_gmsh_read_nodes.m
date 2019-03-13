mp_test_register('gmsh_read_nodes', 'Test reading nodes')
fid = mp_test_data_fopen('rectangle_with_regions.msh'); 
try
  [nodes, nodemap] = mp_gmsh_read_nodes(fid);
  mp_test_assert_equal((1:8)', nodemap);
  mp_test_assert_equal_double([2,1,0], nodes(3,:), 1e-8);
  mp_test_assert_equal_double([1.5,0.5,0], nodes(8,:), 1e-8);
catch exception
  mp_test_set_status('FAILURE')
  rethrow(exception)
end
