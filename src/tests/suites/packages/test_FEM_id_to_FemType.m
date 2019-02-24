mp_test_register('FEM_id_to_FemType', 'Testing convertion int -> FemType')

fem = mp.Fem.FemType.fromId(1);
mp_test_assert_equal(mp.FEM.FemType.Line2, fem)
