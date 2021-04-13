function [ version ] = mp_gmsh_version(format)
  % Return version string of GMSH. As as side effect this functions
  % sets up GMSH.
  arguments
     format (1,1) string  = 'major.minor.patch'
  end
  global mp_GMSH_SETUP
  mp_setup_gmsh();
  command = sprintf('%s --version', mp_GMSH_SETUP.path);   
  [status, result] = system(command);
  if status == 0
    version = strip(result);
    mp_GMSH_SETUP.version = version;
  else
    version = ['Error: ', result];
  end  
  % Extract version components according to te format
  v = strsplit(version, '.');
  fmtmap = struct('major', v(1), 'minor', v(2), 'patch', v(3));
  vs = {};
  try
    for f = strsplit(format, '.')
        vs = [vs, fmtmap.(f{:})];
    end
  catch ME
    causeException = MException('MATLAB:nadamak','invalid version component, should be one of: major, minor, patch');
    ME = addCause(ME,causeException);
    rethrow(ME)
  end    
  version = strjoin(vs, '.');
end