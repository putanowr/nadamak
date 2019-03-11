%% Get fid from fid_or_name argument
%
function [fid, needclose] = mp_get_fid(fid_or_name, varargin)
  mode = 'r';
  if nargin > 1
    mode = varargin{1};
  end 
  needclose = false;
  if ischar(fid_or_name)
    fid = fopen(fid_or_name, mode);
    needclose = true;
  else
    fid = fid_or_name;
  end
end