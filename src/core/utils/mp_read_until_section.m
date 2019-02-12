%% Consume lines from file until line with pattern is encountered.
function [lines] = mp_read_until_section(fid, pattern)
  lines = 0;
  while 1
    tline = fgetl(fid);
    lines = lines + 1;
    if ischar(tline)
      if regexp(tline, pattern)
        return
      end 
    else
      error('Did not encounter line matching: %s', pattern)
    end
  end
end
