%% Get nodes of element.
%
function [nodesId] = mp_gmsh_element_nodes(elemrec)
  nnodes = mp_gmsh_node_count(elemrec(2));
  nodesId = elemrec(end-nnodes+1:end);
end