%% Read element data into cell array.
% TODO : finish documentation.
function [elements] = mp_gmsh_read_elements(fid_or_name)
  [fid, needclose] = mp_get_fid(fid_or_name);
  mp_read_until_section(fid, '\$Elements');
  tline = fgetl(fid);
  n = sscanf(tline, '%d');
  elements = cell(1, n); %preallocate memory
  for i = 1:n
    tline = fgetl(fid);
    elements{i} = sscanf(tline,'%d', [1,inf]);
  end
  mp_read_end_section(fid, '\$EndElements');
  if needclose
    fclose(fid);
  end
end
