%% Open test data file for reading.
% The filenae should be path relative to tests/data folder 
function [fid] = mp_test_data_fopen(filename)
  global mp_TEST
  path = fullfile(mp_TEST.datadir, filename);
  fid = fopen(path, 'r');
end 
