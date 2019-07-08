mp_test_register('bc2tag', 'Test conversion from BcType to FlagSHyp tag');
bc2tag = @mp.exports.flagshyp.bc2tag;
var = 'Displacement'
mp_test_assert_equal(0, bc2tag(mp.BcFactory('NotSet', var), 3));
mp_test_assert_equal(1, bc2tag(mp.BcFactory('FixityX', var), 3));
mp_test_assert_equal(2, bc2tag(mp.BcFactory('FixityY', var), 3));
mp_test_assert_equal(3, bc2tag(mp.BcFactory('FixityXY', var), 3));
mp_test_assert_equal(4, bc2tag(mp.BcFactory('FixityZ', var), 3));
mp_test_assert_equal(5, bc2tag(mp.BcFactory('FixityXZ', var), 3));
mp_test_assert_equal(6, bc2tag(mp.BcFactory('FixityYZ', var), 3));
mp_test_assert_equal(7, bc2tag(mp.BcFactory('Fixity', var), 3));
bcval.value = [0,0,nan];
mp_test_assert_equal(3, bc2tag(mp.BcFactory('Displacement', var, bcval), 3));
bcval.value = [0, nan];
mp_test_assert_equal(1, bc2tag(mp.BcFactory('Displacement', var, bcval), 2));
