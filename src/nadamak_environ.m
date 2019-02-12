function [mypathstr] = nadamak_environ()
% nadamak_environ - set environment to make possible running tests.
% This account to adding paths for Matlab to find required m-files
% of Nanamak code. 
%
% Return the path to the folder in which source code of this 
% function is located.
  persistent pth
  if isempty(pth)
    sep = filesep();
    mypath = mfilename('fullpath');
    [pth,~,~] = fileparts(mypath);
  else
    mypathstr = pth;  
    return
  end
  mypathstr = pth;  
  % Essential bootstrap code
  codeFolders = {'packages';
                 'tests'
                };
  codeFolders = strcat(mypathstr, sep, codeFolders);
  addpath(codeFolders{:})

  % Core folders
  codeFolders = {fullfile('core', 'geom');
                 fullfile('core', 'gmsh');
		 fullfile('core', 'mesh');
		 fullfile('core', 'setup');
		 fullfile('core', 'logging');
		 fullfile('core', 'utils');
                 };
  codeFolders = strcat(mypathstr, sep, codeFolders);
  addpath(codeFolders{:})

  if mp_is_octave()
    portingFolder = fullfile(mypathstr, 'core', 'utils', 'porting', 'octave');
    addpath(portingFolder); 
  end

  % Demo folder
  codeFolders = {'demo';
                 };
  codeFolders = strcat(mypathstr, sep, '..', sep, codeFolders);
  addpath(codeFolders{:})

  % External folders 
  codeFolders = {fullfile('external', 'ini2struct');
                 fullfile('external', 'rgb');
                 fullfile('external', 'dualmesh')
                 fullfile('external', 'calfem', 'fem');
                 };
  codeFolders = strcat(mypathstr, sep, '..', sep, codeFolders);
  addpath(codeFolders{:})

end
