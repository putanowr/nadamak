function [mypathstr] = mp_test_set_environ()
% mp_set_test_environ - set environment to make possible running tests.
% This account to adding paths for Matlab to find required m-files
% of Nadamak code. 
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
  codeFolders = {'logging';
                 'setup';
                 'utils';
                 'interface';
                 'kernel';
                 'plotting';
                 'packages';
                 'runner';
                 'tests';
                 'demo'
                };
  codeFolders = strcat(mypathstr, sep, '..', sep, codeFolders);
  addpath(codeFolders{:})

  % Other folders 
  codeFolders = {fullfile('external', 'ini2struct');
                 fullfile('external', 'rgb');
                 fullfile('external', 'dualmesh')
                 fullfile('external', 'calfem', 'fem');
                 fullfile('mesher', 'gmsh');
                 fullfile('mesher', 'mesh');
                 fullfile('kernel', 'sm');
                 };
  codeFolders = strcat(mypathstr, sep, '..', sep, codeFolders);
  addpath(codeFolders{:})

  if mp_is_octave()
    portingFolder = fullfile(mypathstr, '..', 'utils', 'porting', 'octave');
    addpath(portingFolder); 
  end
end
