function [ geopath ] = mp_meshingOptions_geopath(meshingOptions)
  folder = mp_meshingOptions_folder(meshingOptions);
  fname = mp_meshingOptions_filename(meshingOptions);
  geopath = fullfile(folder, fname);
end
