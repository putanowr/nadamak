function [mypathstr] = nadamak_environ(params)
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
  if nargin < 1
    params = struct;
  end
 
  % Path to nadamak_environ folder
  addpath(mypathstr);
  % Essential bootstrap code
  codeFolders = {'packages';
                 'tests'
                };
  codeFolders = strcat(mypathstr, sep, codeFolders);
  addpath(codeFolders{:})
  
  % Core folders
  codeFolders = {fullfile('core', 'code_generation');
                 fullfile('core', 'geom');
                 fullfile('core', 'gmsh');
                 fullfile('core', 'interface');
                 fullfile('core', 'logging');
                 fullfile('core', 'mesh');
                 fullfile('core', 'plotting');
                 fullfile('core', 'setup');
                 fullfile('core', 'utils');
                 'demos';
                 fullfile('applications', 'sofview');
                 };
  codeFolders = strcat(mypathstr, sep, codeFolders);
  addpath(codeFolders{:})

  if mp_is_octave()
    portingFolder = fullfile(mypathstr, 'core', 'utils', 'porting', 'octave');
    addpath(portingFolder); 
  end

  % External folders 
  codeFolders = {fullfile('external', 'cprintf');
                 fullfile('external', 'ini2struct');
                 fullfile('external', 'rgb');
                 fullfile('external', 'dualmesh')
                 fullfile('external', 'calfem', 'fem');
		 fullfile('external', 'chebfun');
                 };
  codeFolders = strcat(mypathstr, sep, '..', sep, codeFolders);
  addpath(codeFolders{:})

  % generate some source codes
  verbose = mp_get_option(params, 'verbose', false);
  
  pth = fullfile(mypathstr, 'packages', '+mp', '+FEM');
  mp_generateShapeFunctions(pth, verbose);
end
