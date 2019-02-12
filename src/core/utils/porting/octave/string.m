function [outstr] = string(x)
% This function is Octave replacement for Matlab string() function.
% Caution - this handles only the basic case of converting arguments
% to cell array. This function is not fully compatible with Matlab version.
  outstr = {};
  for xi = x
    si = sprintf('%g', xi);
    outstr = [outstr, si];
  end
end
