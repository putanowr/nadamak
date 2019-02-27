mp_test_register('files_recursively', 'Test searching files recursively')
mypath = mfilename('fullpath');
[folder, ~, ~] = fileparts(mypath);
folder = fullfile(folder, '..', '..', '..','core','geom');
files = mp_files_recursively(folder, '.tpl');
mp_test_assert_equal(12, length(files));
