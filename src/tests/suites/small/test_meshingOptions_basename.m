mp_test_register('meshingOptions_basename', 'extract basename from meshing options')
expectedBasename = 'foo';
meshingOptions.basename = expectedBasename;
actualBasename = mp_meshingOptions_basename(meshingOptions);
mp_test_assert_equal(expectedBasename, actualBasename)