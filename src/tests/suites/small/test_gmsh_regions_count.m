mp_test_register('gmsh_regions_count', 'Test counting regions matching selection')
fid = mp_test_data_fopen('rectangle_with_regions.msh'); 
try
  regions = mp_gmsh_read_regions(fid);
  selector = struct('dim', 1);
  mp_test_assert_equal(4, mp_gmsh_regions_count(regions, selector));  
  selector = struct('regexp', 'west');
  mp_test_assert_equal(1, mp_gmsh_regions_count(regions, selector));
  selector = struct('name', {{'west', 'east'}});
  mp_test_assert_equal(2, mp_gmsh_regions_count(regions, selector));
catch exception
  mp_test_set_status('FAILURE')
  rethrow(exception)
end
