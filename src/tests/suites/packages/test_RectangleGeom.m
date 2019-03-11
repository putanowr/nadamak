mp_test_register('construct_RectangleGeom', 'Testing RectangleGeom constructor')
geom = mp.geoms.RectangleGeom('mygeom');
mp_test_assert_equal(2.0, geom.params.da)
