function mp_setup_gmsh( varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
  global mp_GMSH_SETUP
  if ~isempty(varargin)
    configFile = varargin{1};
    ini = ini2struct(configFile);
    mp_GMSH_SETUP = ini.gmsh;
    mp_log(['Gmsh setup created form file: ', configFile]);
  else
    mp_GMSH_SETUP.path = mp_set_gmsh_path();
    mp_GMSH_SETUP.version = 'Not yet determined. Run mp_gmsh_version';
    mp_log('Gmsh setup from built-in data');
  end    
end

function [gmshpath] = mp_set_gmsh_path()
  if isunix() % Unix
    [~, res] = system('hostname');
    hostname = deblank(res);
    if strcmp(hostname, 'jinx')
      mypath = mfilename('fullpath');
      [mydir,~,~] = fileparts(mypath);      
      gmshpath = fullfile(mydir, '../../wrappers/gmsh_jinx');
    else
      gmshpath = 'gmsh';  
    end 
  else % Windows
    gmshpath = 'gmsh';  
	  gmshpath = 'C:\\Users\\roman\\anaconda3\\envs\\humsim\\Library\\bin\\gmsh';
    hostname = getenv('computername');
  end % system type 
end
