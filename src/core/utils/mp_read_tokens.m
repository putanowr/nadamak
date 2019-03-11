%% Read line and split it into white string separated tokens.
%  * mp_read_tokens(fid)
%  * mp_read_tokens(fid, ntok)
% Can be called with optional second argument which is expected number of tokens.
function [tokens] = mp_read_tokens(fid, varargin)
  tline = fgetl(fid);
  tokens = [];
  if ischar(tline)
    tokens = strsplit(tline);
    if nargin > 1
      ntok = varargin{1};
      if length(tokens) ~= ntok
        fclose(fid);
        error('Expected line with %d tokens, got %d', ntok, length(tokens))
      end
    end
  end
end