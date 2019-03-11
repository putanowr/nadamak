function [ option ] = mp_meshingOptions_showinfo(meshingOptions)
  if isfield(meshingOptions, 'showinfo')
    option = meshingOptions.showinfo;
  else
    option = false; 
  end
end
