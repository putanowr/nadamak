mp_test_register('makeBcSelector', 'Test creatioin of bc selector');
bcr = mp.BcRegistry();
bc = mp.BcFactory.produce('Fixity', 'Displacement');
bcr.register('boundaryA', bc);
bc = mp.BcFactory.produce('FixityX', 'Displacement');
bcr.register('boundaryB', bc);

mapper = mp.exports.flagshyp.makeBcMapper(bcr);
mp_test_assert_equal(7, mapper.boundaryA);
mp_test_assert_equal(1, mapper.boundaryB);
