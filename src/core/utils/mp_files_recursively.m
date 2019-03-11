%% Return array of structures describing files found recursively in subdirectories of given directory.
%  Each array element is structure with the fields 'basename', 'folder', 'path'. 
function [files] = mp_files_recursively(directory, extension)
  if mp_is_octave()
    files = mp_files_recursively_octave(directory, extension);
  else
    files = mp_files_recursively_matlab(directory, extension);
  end
end

function [files] = mp_files_recursively_matlab(directory, extension)
  if ~isempty(extension) && extension(1) ~= '.' 
    extension = ['.', extension];
  end
  dirInfo = dir(fullfile(directory, '**', ['*', extension]));
  n = length(dirInfo);
  files = struct('basename', cell(1, n), 'folder', cell(1, n), 'path', cell(1, n));
  for i=1:length(dirInfo)
    [~,f,~] = fileparts(dirInfo(i).name);
    files(i).basename = f; 
    files(i).folder = dirInfo(i).folder;
    files(i).path = fullfile(dirInfo(i).folder, dirInfo(i).name); 
  end
end


function [files] = mp_files_recursively_octave(directory, extension)
  fp = mp_paths_recursively(directory, extension);
  n = length(fp);
  files = struct('basename', cell(1, n), 'folder', cell(1, n), 'path', cell(1, n));
  for i=1:n
    [d,f,~] = fileparts(fp{i});
    files(i).basename = f;
    files(i).folder = d;
    files(i).path = fullfile(d, f); 
  end
end

function [fpaths] = mp_paths_recursively(directory, extension)
  if ~isempty(extension) && extension(1) ~= '.' 
    extension = ['.', extension];
  end
  directory = make_absolute_filename(directory);
  fpaths = glob(fullfile(directory, ['*', extension]));
  dirs = dir(make_absolute_filename(directory));
  dirs = dirs(3:end);
  for i=1:length(dirs)
    if dirs(i).isdir
      d = fullfile(directory, dirs(i).name);
      fpaths = [fpaths; mp_paths_recursively(d, extension)];
    end
  end 
end
