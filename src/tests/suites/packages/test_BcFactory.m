mp_test_register('producer_BcFactory', 'Testing BcFactory producer')
for  t = mp.BcType.validBcForDisplacement
  bc = mp.BcFactory(t, 'Displacement', struct())
  mp_test_assert(t == bc.type);
  mp_test_assert(strcmp('Dispalcement', bc.variable)); 
end
