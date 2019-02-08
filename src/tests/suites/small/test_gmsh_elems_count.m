mp_test_register('gmsh_elems_count', 'Test counting elements')
fid = mp_test_data_fopen('rectangle_with_regions.msh'); 
try
  elements = mp_gmsh_read_elements(fid);
  mp_test_assert_equal(18, mp_gmsh_elems_count(elements, struct()));
  selector = struct('type', [15]);
  mp_test_assert_equal(4, mp_gmsh_elems_count(elements, selector))
  selector = struct('type', [1], 'geom', [1]);
  mp_test_assert_equal(2, mp_gmsh_elems_count(elements, selector));
  selector = struct('region', [1], 'geom', [1]);
  mp_test_assert_equal(8, mp_gmsh_elems_count(elements, selector));
catch exception
  mp_test_set_status('FAILURE')
  rethrow(exception)
end
