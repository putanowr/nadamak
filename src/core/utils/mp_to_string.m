function [outstr] = mp_to_string(object)
% Convert object to string representation
  if ismatrix(object)
    outstr = mat2str(object);
  elseif ischar(object)
    outstr = object;
  else
    error('Do not know how to transfer object to string')
  end
end
