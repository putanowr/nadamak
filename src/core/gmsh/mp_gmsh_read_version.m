%% Read file version
% TODO : fill the documentation
function [major, minor, isascii] = mp_gmsh_read_version(fid_or_name)
  [fid, needclose] = mp_get_fid(fid_or_name);
  mp_read_until_section(fid, '\$MeshFormat');
  tline = fgetl(fid);
  data = sscanf(tline, '%f %d %d')
  major = floor(data(1));
  minor = round((data(1)-major)*10);
  isascii = data(2);
  mp_read_end_section(fid, '\$EndMeshFormat');
  if needclose
    fclose(fid);
  end
end