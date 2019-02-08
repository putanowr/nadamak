%% Read data into array of region structures. 
function [nodes, nodemap] = gmsh_read_nodes(fid_or_name)
  [fid, needclose] = mp_get_fid(fid_or_name);
  mp_read_until_section(fid, '\$Nodes');
  tline = fgetl(fid);
  n = sscanf(tline, '%d');
  data = fscanf(fid, '%f', [4, n]); 
  nodes = mp.SharedArray([n, 3]);
  nodemap = mp.SharedArray([n, 1]);
  nodes.Data(:,:) = data(2:4,:)';
  nodemap.Data(:) = data(1,:)';
  fgetl(fid); % This call is to consume new line character
  mp_read_end_section(fid, '\$EndNodes');
  if needclose
    fclose(fid);
  end
end
