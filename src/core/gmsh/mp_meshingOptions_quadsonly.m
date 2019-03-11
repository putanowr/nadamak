function [ option ] = mp_meshingOptions_quadsonly(meshingOptions)
  if isfield(meshingOptions, 'quadsonly')
    option = meshingOptions.showinfo;
  else
    option = false; 
  end
end