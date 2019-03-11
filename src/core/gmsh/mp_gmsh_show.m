%% Call GMSH program
% mp_gmsh Call Gmsh to generate mesh from given geometric model and meshing options 
% Arguments:
% geoModel - string containing GMSH geometric model
% meshingOptions - structure contining meshing options
function [ retval ] = mp_gmsh_show(geoModel, meshingOptions)
  global mp_GMSH_SETUP
  retval = false;

  if isfield(meshingOptions, 'quadsonly')
    if meshingOptions.quadsonly
      meshingOptions.quadsonly = 1;
    else
      meshingOptions.quadsonly = 0;
    end 
  else
    meshingOptions.quadsonly = 0;
  end 
  if exist('mp_GMSH_SETUP', 'var')
    geoModel = mp_tpl_substitute(geoModel, meshingOptions);
    geopath = mp_meshingOptions_geopath(meshingOptions);
    dim = mp_meshingOptions_dim(meshingOptions);
    verbosity = mp_meshingOptions_verbosity(meshingOptions);
    showinfo = mp_meshingOptions_showinfo(meshingOptions);
    fid = fopen(geopath,'w');
    fprintf(fid, '%s', geoModel);
    fclose(fid);
    command = sprintf('%s "%s" -v %d', ...
                      mp_GMSH_SETUP.path, ...
                      geopath, ...
                      verbosity);   
    [status, result] = system(command);
    if showinfo 
      disp(result)
    end
    retval = (status == 0);
  else
      msg = ['Gmsh setup structure does not exists.' ...
             'Maybe forgt to call setup_gmsh'];
      error(msg)
  end
end
