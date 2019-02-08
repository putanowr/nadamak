function mp_test_finalize()
  global mp_TEST
  ntests = length(fieldnames(mp_TEST.registry));
  fprintf(mp_TEST.summaryfid, 'Run %d tests\n', ntests);
  fclose(mp_TEST.summaryfid);
  fclose(mp_TEST.statusfid);
end
