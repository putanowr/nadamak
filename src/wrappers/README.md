This directory provides wrappers over the third party program that are called from within MATLAB.
The wrappers set the proper environment in which the programs are called. This might be necessary
because matlab sets its own LD_LIBRARY_PATH for the system() call.
