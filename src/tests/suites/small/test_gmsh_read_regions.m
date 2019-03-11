mp_test_register('gmsh_read_regions', 'Test reading regions data')
fid = mp_test_data_fopen('rectangle_with_regions.msh'); 
try
  regions = mp_gmsh_read_regions(fid);
  mp_test_assert_equal(6, length(regions));
  mp_test_assert_equal(0, regions(1).dim);
  mp_test_assert_equal(5, regions(5).id);
  mp_test_assert_equal('corners', regions(1).name);
catch exception
  mp_test_set_status('FAILURE')
  rethrow(exception)
end
