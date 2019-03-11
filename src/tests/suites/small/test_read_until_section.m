mp_test_register('read_until_section', 'Test skiping lines till keyword')
fid = mp_test_data_fopen('skip_sections.txt'); 
try
  lines = mp_read_until_section(fid, '.ection_1');
  mp_test_assert_equal(4, lines)
  tline = fgetl(fid);
  mp_test_assert_equal('line A', tline)
catch exception
  mp_test_set_status('FAILURE')
  rethrow(exception)
end
caught = false;
try 
  lines = mp_read_till_section(fid, 'jan');
catch exception
  caught = true;
  mp_test_set_status('OK')
end
if ~caught
  mp_test_set_status('FAIL')
  error('Did not caught legitimate exception') 
end 
% There is no need for explicit closing of fid as it will be automatically closed in throw/catch.
