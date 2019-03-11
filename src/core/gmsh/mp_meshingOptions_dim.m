function [ dim ] = mp_meshingOptions_dim(meshingOptions)
  if isfield(meshingOptions, 'dim')
    dim = meshingOptions.dim;
  else
    dim = 2;
  end
end