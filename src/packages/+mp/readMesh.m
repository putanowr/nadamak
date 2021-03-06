function [mesh] = readMesh(fid_or_name)
  %% Read given file and returns new Mesh object.
  [fid, needclose] = mp_get_fid(fid_or_name);
  [major_version, ~, ~] = mp_gmsh_read_version(fid);
  regions = mp_gmsh_read_regions(fid, major_version);
  [nodes, nodemap] = mp.gmsh.read_nodes(fid, major_version);  
  elements = mp.gmsh.read_elements(fid, major_version);
  if needclose
    fclose(fid);
  end
  elemInfo = mp_gmsh_elems_info(elements);
  mesh = mp.Mesh(elemInfo.dim, nodes, elements, regions, nodemap);
end
