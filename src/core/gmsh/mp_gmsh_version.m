function [ version ] = mp_gmsh_version()
  % Return version string of GMSH. As as side effect this functions
  % sets up GMSH.
  global mp_GMSH_SETUP
  mp_setup_gmsh();
  command = sprintf('%s --version', mp_GMSH_SETUP.path);   
  [status, result] = system(command);
  if status == 0
    version = strip(result);
    mp_GMSH_SETUP.version = version
  else
    version = ['Error: ', result];
  end  
end