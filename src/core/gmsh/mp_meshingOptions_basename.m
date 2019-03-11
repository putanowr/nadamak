function [ fname ] = mp_meshingOptions_basename(meshingOptions)
  if isfield(meshingOptions, 'basename')
    fname = meshingOptions.basename;
  else
    fname = ['for_gmsh_', tempname()];
    [dir, f, ext] = fileparts(fname);
    fname = [f, ext];
  end
end