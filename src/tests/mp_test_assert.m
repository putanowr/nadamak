function mp_test_assert(status, varargin)
% Test if assertion is true. If not raise
% error. Write appropriate message.
  if ~status
    mp_test_set_status('FAILURE')
    details = '  Details : none';
    if ~isempty(varargin)
       details=sprintf('  Details : %s', varargin{:});
    end
    error('Test assertion FAILED:\n%s', details)
  else
    mp_test_set_status('OK')
  end  
end                
