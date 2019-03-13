function [nodes, elements, regions, nodemap] = mp_gmsh_read_mesh(fid_or_name)
  %% Read mesh into array data. 
  [fid, needclose] = mp_get_fid(fid_or_name);
  regions = mp_gmsh_read_regions(fid);
  [nodes, nodemap] = mp_gmsh_read_nodes(fid);  
  elements = mp_gmsh_read_elements(fid);
  if needclose
    fclose(fid);
  end
end
