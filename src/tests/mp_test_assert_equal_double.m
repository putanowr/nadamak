function mp_test_asssert_equal(expected, actual, epsilon, varargin)
% Test if actuall is equal expected. If not raise
% error. Write appropriate message.
  esize = size(expected);
  asize = size(actual);
  details = '  Details : none';
  if ~isempty(varargin)
    details = sprintf('  Details : %s', varargin{:});
  end
  if esize ~= asize
    mp_test_set_status('FAILURE')
    error('Test assertion FAILED: size does not match\n%s', details)
  end 
  for i=1:size(expected)
    if abs(expected(i)-actual(i)) > epsilon
      estr = sprintf(' Expected : %s\n',mp_to_string(expected));
      astr = sprintf('   Actual : %s\n',mp_to_string(actual));
      mp_test_set_status('FAILURE')
      error('Test assertion FAILED:\n%s\n%s\n%s\n', estr, astr, details)
    end
  end  
  mp_test_set_status('OK')  
end                
