mp_test_register('rectangle_geom', 'Testing generation of rectangle geometry')
global mp_TEST
gmshgeom = mp_geom_rectangle([0,0], [2,1], struct('lc',1.0));
meshingParams.basename ='rectangle';
meshingParams.dim = 2;
meshingParams.folder = mp_TEST.testdir;
meshingParams.verbosity = 4;
[status, stdout, stderr] = mp_gmsh(gmshgeom, meshingParams);
mp_test_assert_equal(true, status)
