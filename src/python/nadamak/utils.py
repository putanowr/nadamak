# -*- coding: utf-8 -*-
import socket
import sys

if sys.version_info[1] > 4:
  from subprocess import run, PIPE
else:
  import subprocess

def echo_file(fname):
  """Echo given file to standard output."""
  with open(fname) as file:
    for line in file:
      line = line.replace(u'×', 'x')
      print(line, end='', flush=True)

def get_interpreter_path(args):
  """Return path to Matlab or Octave binaries
  """
  binaries = {'matlab' : {'jinx' : 'matlab-2017a'},
              'octave' : {'Lap025' : r'O:\WinProg\Octave-4.2.1\bin\octave-cli.exe'}
             } 
  defaultbinaries = {'matlab' : 'matlab', 
                     'octave' : 'octave'}
  hostname = socket.gethostname()
  if args.path == 'builtin':
    program = binaries[args.environ].get(hostname, defaultbinaries[args.environ])	
  else:
    program = args.path
  return program

def get_matlab_args(args, command):
  """Return command line for running matalb.
  """
  program = get_interpreter_path(args)
  matlab_args = [program, 
          '-nosplash', 
          '-nodesktop', 
          '-minimize',
          '-r', 
          command,
          '-logfile',
          args.logfile,  
          '-wait',
         ]
  return matlab_args

def get_octave_args(args, command):
  """Return command line for running Octave
  """
  program = get_interpreter_path(args)
  octave_args = [program,
                  '--quiet', 
                  '--eval',
                  command
                ]
  return octave_args

def resolve_verbosity(args):
  verbosity_levels = {'summary':1, 'status':2, 'full':3 }
  verbosity = verbosity_levels[args.verbosity]
  return verbosity

def run_matlab_or_octave(args, command, timeout=300):
  
  matlab_args = get_matlab_args(args, command)
  octave_args = get_octave_args(args, command)

  verbosity = resolve_verbosity(args)
  
  if sys.version_info[1] > 4:
    if args.environ == 'matlab':
      results = run(matlab_args, stdout=PIPE, stderr=PIPE, timeout=timeout)
      if verbosity > 2:
        echo_file(args.logfile)
    elif args.environ == 'octave':
      results = run(octave_args, stdout=PIPE, stderr=PIPE, timeout=timeout, universal_newlines=True)
      if verbosity > 2:
        if results.stdout:
          print(results.stdout)
        if results.stderr:
          print(results.stderr)
    returncode = results.returncode
  else:
    if args.environ == 'matlab':
      returncode = subprocess.call(matlab_args, timeout=timeout)
      echo_file(args.logfile)
    elif args.environ == 'octave':
      returncode = subprocess.call(octave_args, timeout=timeout, universal_newlines=True)

  return returncode
