function mp_run_tests(varargin)
% mp_run_test : run all scripts in tests directory that match the pattern
%               test_*.m
% Arguments
%   options - structure with the following fiels:
%     exitAfter - boolean, if true call exit fater running tests
%     filter - string, regular expression for selecting tests to run
  if nargin > 0
    options = varargin{:};
  else
    options.exitAfter = false;
    options.filter = '.*';
  end

  if ~isfield(options, 'exitAfter')
    options.exitAfter = false;
  end

  if ~isfield(options, 'filter')
    options.filter = '.*';
  end

  if ~isfield(options, 'suite')
    options.suite = '';
  end

  if ~isfield(options, 'suiteexclude')
    options.suiteexclude = '.*';
  end

  exitCode=0;
  try
    sep = filesep();
    mypath = mfilename('fullpath');
    [pth,~,~] = fileparts(mypath);
    srcFolder = fullfile(pth,'..');
    addpath(srcFolder);

    nadamakpath = nadamak_environ();
    mp_setup_logging(true);
    mp_setup_gmsh()
 
    % Initialize unit testing framework
    mp_test_initialize(options)

    suitePath = 'suites';
    if ~isempty(options.suite)
       suitePath = fullfile(suitePath, options.suite);
    end 
   
    tests = mp_files_recursively(fullfile(pth, suitePath), '.m');

    for i=1:length(tests)
       testname = tests(i).basename;
       folder = tests(i).folder;
       if ~isempty(regexp(folder, options.suiteexclude, 'once'))
         continue
       end 
       if isempty(regexp(testname, options.filter, 'once'))
         continue
       end 
       try 
         mp_test_run_shilded(tests(i).path)
         fprintf(1, 'PASSED %s\n', testname) 
       catch exception
         fprintf(1, 'FAILED %s\n', testname) 
         fprintf(1, '  Reason: %s\n', exception.message)
         mp_test_report_exception(1, exception)
         exitCode=2;
       end
    end
  catch exception
    disp('Exception catched in mp_run_tests')
    disp(exception.message)
    exitCode=22;
  end
 
  mp_test_finalize()
 
  if options.exitAfter
    exit(exitCode)
  end   
end
