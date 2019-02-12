%% Run test script inside function scope.
% Arguments:
%    path - absolute path to the test script
% This function wraps test code inside function scope so the test are run
% independently.
function mp_test_run_shilded(path)
   run(path)
end
