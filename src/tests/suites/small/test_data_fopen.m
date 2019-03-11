mp_test_register('data_fopen', 'Test opening test data file')
fid = mp_test_data_fopen('vector_3d.txt');
tline = fgetl(fid);
mp_test_assert_equal('1 2 3', tline);
fclose(fid);
