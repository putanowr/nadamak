mp_test_register('legpts', 'Test if legpts from Chebfun package is available')
[x, w] = legpts(1, [0, 1]);
mp_test_assert_equal_double(0.5, x(1), 1e-8);
mp_test_assert_equal_double(1.0, w(1), 1e-8);
