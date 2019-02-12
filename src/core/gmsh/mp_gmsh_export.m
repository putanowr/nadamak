%% Call GMSH program
% mp_gmsh Call Gmsh to generate mesh from given geometric model and meshing options 
% Arguments:
% geoModel - string containing GMSH geometric model
% meshingOptions - structure contining meshing options
function [outpath] = mp_gmsh_export(inputmeshfile, outputmeshfile)
  global mp_GMSH_SETUP
  retval = false;
  showinfo=true;
  if exist('mp_GMSH_SETUP', 'var')
    command = sprintf('%s "%s" -format vtk -o %s', ...
                      mp_GMSH_SETUP.path, ...
                      inputmeshfile, outputmeshfile);
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
  outpuath = outputmeshfile;
end