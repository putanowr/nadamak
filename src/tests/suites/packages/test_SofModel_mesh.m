mp_test_register('SofModel_mesh', 'Testing creation of mesh in SofModel')
sof = SofModel();
[status, msg] = sof.setProblem('mechanical', 'square');
mp_test_assert(status, msg);
meshParams.lc = 0.5;
[status, msg] = sof.generateMesh(meshParams);
mp_test_assert(status, msg);
mesh = sof.getMesh('mainmesh');
mp_test_assert_equal(2, mesh.dim);