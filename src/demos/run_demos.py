"""Driver to publish Nadamak demos in HTML"""

import os
import socket
import sys
import re
import distutils.dir_util

if sys.version_info[1] > 4:
  from subprocess import run, PIPE
else:
  import subprocess

import argparse
sys.path.append(os.path.join(os.path.dirname(__file__), "../python"))
from nadamak.utils import *

def setup_parser():
  parser = argparse.ArgumentParser(description='Run Nadamak unit tests')
  parser.add_argument('--filter',
                      dest='filter', 
                      default='.*',
                      help='Regular expression to filter demos to be run',
                     )
  parser.add_argument('--publishdir',
                      dest='publishdir', 
                      default='',
                      help='Directory in which to publish the demos',
                     )
  parser.add_argument('--rundir',
                      dest='rundir', 
                      default='',
                      help='Directory in which to run demo',
                     )
  return parser


def get_matlab_demo_args(args):
  """Return command line for running matalb.
  """
  if socket.gethostname() == 'jinx':
    matlabCommand = 'matlab-2017a'
  elif socket.gethostname() == 'LAP025':
    matlabCommand = 'O:/WinProgs/MATLAB/2018a/bin/matlab.exe'
  else:
    matlabCommand = 'matlab'

  scriptpath = os.path.dirname(os.path.abspath(__file__))

  command = "addpath('%s');" \
            "mp_run_demos(struct(" \
            "'exitAfter', %d," \
            "'demodir', '%s'" \
            "))" % (scriptpath, 1, args.publishdir)
  args = [matlabCommand,
          '-nosplash', 
          '-nodesktop', 
          '-minimize',
          '-r', 
          command, 
          '-logfile',
          'demogen.log', 
          '-wait'
         ]
  return args

if __name__ == '__main__' :
  parser = setup_parser();

  args = parser.parse_args()
  
  matlab_args = get_matlab_demo_args(args)
  
  rootDir = os.path.dirname(os.path.abspath(__file__))

  if not os.path.isdir(args.rundir):
      os.mkdir(args.rundir)

  os.chdir(args.rundir)

  if not os.path.isdir(args.publishdir):
      os.mkdir(args.publishdir)

  distutils.dir_util.copy_tree(os.path.join(rootDir, 'html'), args.publishdir)
  
  print(matlab_args)
  result = run(matlab_args, stdout=PIPE, stderr=PIPE, timeout=1200)
  echo_file('demogen.log')
  exit(result.returncode)
