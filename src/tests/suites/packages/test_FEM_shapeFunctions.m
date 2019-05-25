mp_test_register('FEM_shapeFunctions', 'Testing FEM shape functions')

for fem = enumeration('mp.FEM.FemType')'
  details = sprintf('Check Fem type: %s', fem);
  xy = fem.dofsCoords();
  N = fem.sfh(xy);
  I = eye(size(N));
  check = norm(N-I, 'fro');
  mp_test_assert_equal_double(0.0, check, 1e-5, details); 
end
