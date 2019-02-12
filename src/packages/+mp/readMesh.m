function [mesh] = readMesh(fid_or_name)
  %% Read given file and returns new Mesh object.
  [nodes, elements, regions, nodemap] = mp_gmsh_read_mesh(fid_or_name);
  elemInfo = mp_gmsh_elems_info(elements);
  mesh = mp.Mesh(elemInfo.dim, nodes, elements, regions, nodemap);
end
