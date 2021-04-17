%% Read data into array of region structures. 
function [regions] = mp_gmsh_read_regions(fid_or_name, version)
  arguments
      fid_or_name
      version (1,1) uint32 = 4
  end
  if version == 4
    elements = local_read_regions_ver_4(fid_or_name);
  elseif version == 2
    elements = local_read_regions_ver_2(fid_or_name);
  else
    error('Invalid msh version %d', version)
  end
end

function [regions] = local_read_regions_ver_4(fid_or_name)
  error('Not implemented yet')
  regions = []
end

function [regions] = local_read_regions_ver_2(fid_or_name)
  [fid, needclose] = mp_get_fid(fid_or_name);
  mp_read_until_section(fid, '\$PhysicalNames');
  tline = fgetl(fid);
  n = sscanf(tline, '%d');
  regions = arrayfun(@(K) mp_gmsh_region(), 1:n);
  for i=1:n
    tokens = mp_read_tokens(fid, 3);
    regions(i).dim = str2num(tokens{1});
    regions(i).id = str2num(tokens{2});
    regions(i).name = tokens{3}(2:end-1);
  end
  mp_read_end_section(fid, '\$EndPhysicalNames');
  if needclose
    fclose(fid);
  end
end
