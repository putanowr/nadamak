function mp_test_register(name, brief)
% Register a test in unit tests framework.  
  global mp_TEST
  test.brief = brief;
  test.status = 'RUNNING';
  mp_TEST.registry.(name) = test;
  mp_TEST.current = name;
  fprintf(mp_TEST.statusfid, '\n%s ... ', name);
  cd(mp_TEST.testdir)
end
