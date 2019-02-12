%% Extract value of option.
% This function checks if its first argument is structure and if true,
% extracts and returns named field from it. Otherwise returns the first
% argument.
function [ option ] = mp_get_option(valueOrOptions, name, defaultValue)
  if isstruct(valueOrOptions)
    if isfield(valueOrOptions, name)
      option = valueOrOptions.(name);
    elseif nargin > 2
      option = defaultValue;
    else
      error('Could not find field %s in passed structure', name);
    end  
  else
    option = valueOrOptions;
  end
end