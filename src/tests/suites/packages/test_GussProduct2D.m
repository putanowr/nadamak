mp_test_register('FEM_GaussProdct2D', 'Testing integration by GaussProduct2D')

f = @(x) x(:,1).^2+x(:,2).^2;
g = @(x,y) x.^2+y.^2;

qd = mp.IM.GaussProduct2D(2);

expect = integral2(g, 0, 1, 0, 1);
check = sum(f(qd.pts).*qd.w);

mp_test_assert_equal_double(expect, check, 1e-5); 
