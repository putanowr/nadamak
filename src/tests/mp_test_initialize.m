function mp_test_initialize(options)
% Do preparatory steps to run test suite
  global mp_TEST
  mp_TEST.statusfid = fopen('teststatus.log', 'w');
  mp_TEST.summaryfid = fopen('testsummary.log', 'w');
  mp_TEST.registry = struct();
  mp_TEST.current = '';

  mypath = mfilename('fullpath');
  [mypath,~,~] = fileparts(mypath);

  mp_TEST.datadir = fullfile(mypath, 'data');

  if nargin < 1
    options = struct();
  end
  
  if isfield(options, 'testdir')
    if isempty(fileparts(options.testdir))
      mp_TEST.testdir = fullfile(pwd, options.testdir);
    else
      mp_TEST.testdir = options.testdir;
    end    
  else
    mp_TEST.testdir = tempdir();
  end
  mp_TEST.testdir=strrep(mp_TEST.testdir, '\', '\\');

  if 0 == exist(mp_TEST.testdir, 'dir')
    mkdir(mp_TEST.testdir);
  end

  if 7 ~= exist(mp_TEST.testdir, 'dir')
    error('Cannot access tests directory')
  end
  msg = sprintf('Test directory set to : %s', strrep(mp_TEST.testdir, '\', '\\'));
  mp_log(msg)
end  
