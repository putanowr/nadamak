%% Return new element record with nodes mapped through mapper
%
function [elemrec] = mp_gmsh_map_element_nodes(elemrec, mapper)
  nnodes = mp_gmsh_node_count(elemrec(2));
  elemrec(end-nnodes+1:end) = mapper(elemrec(end-nnodes+1:end));
end