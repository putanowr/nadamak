%% Read line and raise error if it does not match given pattern.
function mp_read_end_section(fid, pattern)
  tline = fgetl(fid);
  if ischar(tline)
    if regexp(tline, pattern)
      return
    end 
  end
  error('Did not encounter line matching: %s', pattern)
end