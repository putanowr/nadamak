function [nodes, elements, regions, nodemap] = mp_gmsh_read_mesh(fid_or_name)
  %% Read mesh into array data. 
  [fid, needclose] = mp_get_fid(fid_or_name);
  [major_version, ~, ~] = mp_gmsh_read_version(fid, major_version);
  regions = mp_gmsh_read_regions(fid, major_version);
  [nodes, nodemap] = mp_gmsh_read_nodes(fid, major_version);  
  elements = mp_gmsh_read_elements(fid, major_version);
  if needclose
    fclose(fid);
  end
end
