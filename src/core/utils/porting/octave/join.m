function [outstr] = join(tokens, separator)
% This function is Octave substitute for join function of Matlab.
% This function concatenates tokens with given separator
  strtokens = strvcat(tokens);
  outstr=deblank(strtokens(1,:));
  for i=2:length(tokens)
    outstr = cstrcat(outstr, separator, deblank(strtokens(i,:)));
  end
end
