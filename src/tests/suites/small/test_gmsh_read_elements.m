mp_test_register('gmsh_read_elements', 'Test reading elements')
fid = mp_test_data_fopen('rectangle_with_regions.msh'); 
try
  [major_version, ~, ~] = mp_gmsh_read_version(fid);
  elements = mp_gmsh_read_elements(fid, major_version);
  mp_test_assert_equal(18, length(elements));
  mp_test_assert_equal([4,15,2,6,4,4], elements{4});
  mp_test_assert_equal([18, 2, 2, 1, 1, 3, 6, 8], elements{18});
catch exception
  mp_test_set_status('FAILURE')
  rethrow(exception)
end
