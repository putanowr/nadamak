%% Call GMSH program
% mp_gmsh Call Gmsh to generate mesh from given geometric model and meshing options 
% Arguments:
% geoModel - string containing GMSH geometric model
% meshingOptions - structure contining meshing options
function [ retval, meshpath, geopath ] = mp_gmsh(geoModel, meshingOptions)
  global mp_GMSH_SETUP
  retval = false;
  meshingOptions.transfinite = mp_get_option(meshingOptions, 'transfinite', 0);
  meshingOptions.transres = mp_get_option(meshingOptions, 'transres', [1,1]);
  meshingOptions.quadsonly = mp_get_option(meshingOptions, 'quadsonly', 0);
  
  if exist('mp_GMSH_SETUP', 'var')
    geoModel = mp_tpl_substitute(geoModel, meshingOptions);
    geopath = mp_meshingOptions_geopath(meshingOptions);
    [d,f,~] = fileparts(geopath);
    meshpath = fullfile(d, [f, '.msh']);
    dim = mp_meshingOptions_dim(meshingOptions);
    verbosity = mp_meshingOptions_verbosity(meshingOptions);
    showinfo = mp_meshingOptions_showinfo(meshingOptions);
    fid = fopen(geopath,'w');
    fprintf(fid, '%s', geoModel);
    fclose(fid);
    command = sprintf('%s "%s" -%d -v %d', ...
                      mp_GMSH_SETUP.path, ...
                      geopath, ...
                      dim, ...
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
