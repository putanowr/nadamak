mp_test_register('producere_Problems', 'Testing ProblemFactory producer')
kind = {{'M',  mp.ProblemType.Mechanical},
        {'T',  mp.ProblemType.Thermal},
        {'TM', mp.ProblemType.ThermoMechanical}};
for  k = kind
  problem = mp.ProblemFactory.produce(k{1}(1));
  mp_test_assert_equal(k{1}(2), problem.type);
end
