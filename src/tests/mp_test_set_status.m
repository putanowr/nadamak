function mp_test_set_status(status)
% Set the status of current test
  global mp_TEST
  if ~strcmp(mp_TEST.current, '')
    mp_TEST.retistry.(mp_TEST.current).('status') = status;
    fprintf(mp_TEST.statusfid, ' %s ', status);
  end
end
