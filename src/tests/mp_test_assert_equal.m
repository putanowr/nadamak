function mp_test_assert_equal(expected, actual, varargin)
% Test if actuall is equal expected. If not raise
% error. Write appropriate message.
  if ~isequal(expected, actual)
    estr = sprintf(' Expected : %s\n',mp_to_string(expected));
    astr = sprintf('   Actual : %s\n',mp_to_string(actual));
    mp_test_set_status('FAILURE')
    details = '  Details : none';
    if ~isempty(varargin)
       details=sprintf('  Details : %s', varargin{:});
    end
    error('Test assertion FAILED:\n%s\n%s\n%s', estr, astr, details)
  else
    mp_test_set_status('OK')
  end  
end                
