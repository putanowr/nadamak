mp_test_register('producer_BcFactory', 'Testing BcFactory producer')
for  t = mp.BcFactory.validBcForDisplacement
  name = 'Displacement';
  bc = mp.BcFactory.produce(t, name, struct());
  mp_test_assert(t == bc.type);
  mp_test_assert(strcmp(name, bc.variable));
end

for  t = mp.BcFactory.validBcForTemperature
  bc = mp.BcFactory.produce(t, 'T', struct());
  mp_test_assert(t == bc.type);
  mp_test_assert(strcmp('Temperature', bc.variable));
end
