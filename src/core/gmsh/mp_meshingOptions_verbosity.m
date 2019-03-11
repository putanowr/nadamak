function [ option ] = mp_meshingOptions_verbosity(meshingOptions)
  if isfield(meshingOptions, 'verbosity')
    option = meshingOptions.verbosity;
  else
    option = 1;
  end
end