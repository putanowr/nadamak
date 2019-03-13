%% Extract folder field from a structure
%
% If structure contains field called 'folder' returns it otherwise
% returs temporary folder.
%
function [ folder ] = mp_meshingOptions_folder(meshingOptions)
  if isfield(meshingOptions, 'folder')
    folder = meshingOptions.folder;
  else
    folder = tempdir();
  end
end