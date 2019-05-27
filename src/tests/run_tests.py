"""Driver to run Nadamak unit tests"""

import sys
import os
import argparse

sys.path.append(os.path.join(os.path.dirname(__file__), "../python"))

from nadamak.utils import *

def get_tests_command(args):
  """Return sting with Matlab/Octave command to be run on start
  """
  scriptpath = os.path.dirname(__file__)
  environpath = os.path.join(scriptpath, '..');
  command = "addpath('%s');" \
            "addpath('%s');" \
            "mp_run_tests(struct(" \
            "'exitAfter', %d," \
            "'filter', '%s'," \
            "'testdir', '%s'," \
            "'environ', '%s'," \
            "'logfile', '%s'," \
            "'suite', '%s'," \
            "'suiteexclude', '%s'" \
            "))" % (environpath,scriptpath, 1, args.filter, args.testdir, args.environ, args.logfile, args.suite, args.suiteexclude)
  return command

def setup_tests_parser():
  parser = argparse.ArgumentParser(description='Run Nadamak unit tests')
  parser.add_argument('--environ',
                      dest='environ',
                      choices=['matlab', 'octave'], 
                      default='matlab',
                      help='Environment to run (matlab/octave)'
                     )
  parser.add_argument('--verbosity',
                      dest='verbosity',
                      choices=['summary', 'status', 'full'], 
                      default='summary',
                      help='Verbosity of the output)'
                     )
  parser.add_argument('--logfile',
                      dest='logfile', 
                      default='tests.log',
                      help='Name of the log file',
                     )
  parser.add_argument('--path',
                      dest='path', 
                      default='builtin',
                      help='Path to environment executable',
                     )
  parser.add_argument('--filter',
                      dest='filter', 
                      default='.*',
                      help='Regular expressio to filter terst to be run',
                     )
  parser.add_argument('--suite',
                      dest='suite', 
                      default='',
                      help='Name of the suite of tests to run',
                     )
  parser.add_argument('--suite-exclude',
                      dest='suiteexclude', 
                      default='',
                      help='Name of the suite of tests to run',
                     )

  parser.add_argument('--testdir',
                      dest='testdir', 
                      default='',
                      help='Directory in which to run tests',
                     )
  return parser

if __name__ == '__main__' :
  parser = setup_tests_parser();

  args = parser.parse_args()
  
  command = get_tests_command(args)

  returncode = run_matlab_or_octave(args, command, timeout=300)

  verbosity = resolve_verbosity(args)

  if verbosity > 1:
    echo_file('teststatus.log')
    print('')
  print('================================')
  echo_file('testsummary.log')
  if returncode == 0:
    print("Tests finished successfully")
  else:
    print("Tests failed with errorstatus %d" % returncode)
  exit(returncode)
