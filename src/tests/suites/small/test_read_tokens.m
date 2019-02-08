mp_test_register('read_tokens', 'Test reading tokens')
fid = mp_test_data_fopen('vector_3d.txt');
try
  tokens = mp_read_tokens(fid);
  mp_test_assert_equal(3, length(tokens));
  mp_test_assert_equal('1', tokens{1});
  mp_test_assert_equal('2', tokens{2});
  mp_test_assert_equal('3', tokens{3});
  frewind(fid)
  tokens = mp_read_tokens(fid, 3);
  frewind(fid)
  caught = false;
  try
    tokens = mp_read_tokens(fid, 2);
  catch exception
    mp_test_set_status('OK')
    caught = true;
  end
  if ~caught 
    error('Did not caught legitimate exception in mp_read_tokens')
  end
catch exception
  mp_test_set_status('FAILURE')
  rethrow(exception)
end
% Throw/catch statement causes open fid to close this is why explicit fclose is not necessary here.
