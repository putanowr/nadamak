mp_test_register('read_end_section', 'Test reading and matching a pattern')
fid = mp_test_data_fopen('skip_sections.txt'); 
try
  lines = mp_read_until_section(fid, '.ection_1');
  for i=1:3
    tline = fgetl(fid);
  end
  mp_read_end_section(fid, 'section_1')
catch exception
  mp_test_set_status('FAIL')
  rethrow(exception)
end
caught = false;
try 
  mp_read_end_section(fid, 'jan');
catch exception
  caught = true;
  mp_test_set_status('OK')
end
if ~caught
  mp_test_set_status('FAIL')
  error('Did not caught legitimate exception') 
end 
% There is no need for explicit closing of fid as it will be automatically closed in throw/catch.
