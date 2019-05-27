%%  Uniformly refine mesh 
% 
function retval = mp_gmsh_refine(inputPath, outputPath, meshingOptions)
  global mp_GMSH_SETUP
  retval = false;

  if nargin < 3
    meshingOptions = struct('nrefinements', 1);
  end

  if exist('mp_GMSH_SETUP', 'var')
    verbosity = mp_meshingOptions_verbosity(meshingOptions);
    showinfo = mp_meshingOptions_showinfo(meshingOptions);
    command = sprintf('%s -refine "%s" -o "%s" -v %d -format msh2', ...
                        mp_GMSH_SETUP.path, ...
                        inputPath, ...
                        outputPath, ...
                        verbosity);
    [status, result] = system(command);
    for i=1:meshingOptions.nrefinements-1
      command = sprintf('%s -refine "%s" -v %d -format msh2', ...
                        mp_GMSH_SETUP.path, ...
                        outputPath, ...
                        verbosity);
      [status, result] = system(command);                
    end
    if showinfo 
      disp(result)
    end
    if status ~= 0
      error('Refining mesh via gmsh has failed')
    end
  else
      msg = ['Gmsh setup structure does not exists.' ...
             'Maybe forgt to call setup_gmsh'];
      error(msg)
  end
end
