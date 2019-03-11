mp_test_register('meshingOptions_dim', 'extract dim from meshing options')
expectedDim = 33;
meshingOptions.dim = expectedDim;
actualDim = mp_meshingOptions_dim(meshingOptions);
mp_test_assert_equal(expectedDim, actualDim);
