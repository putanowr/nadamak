function mp_write_vector(fid, vector, slice, params)
  if nargin < 4
    params.format = '%d';
    params.separator = ' ';
    params.newline = false;
  end
  if isempty(slice)
    first=1;
    last = numel(vector);
  elseif ismissing(slice)
     first = 1;
     last = numel(vector);
  else
     n = numel(slice);
     if n == 1
        first = 1;
        last = slice;
     elseif n == 2
        first = slice(1);
        last = slice(2);
     else
        error('Invalid specification of slice for vector writing');
     end
  end   
  format = mp_get_option(params, 'format', params.format);
  separator = mp_get_option(params, 'separator', params.separator);
  for i=first:last-1
    fprintf(fid, format, vector(i));
    fprintf(fid, separator);
  end
  fprintf(fid, format, vector(last));
  if newline
    fprintf(fid, '\n');
  end
end  
  
