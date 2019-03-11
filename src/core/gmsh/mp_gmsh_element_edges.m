%% Get cell array of node id for element edges
%
% elemrec is numeric array as defined by GMSH msh format.
function [edges] = mp_gmsh_element_edges(elemrec)
  elemType = elemrec(2);
  elemInfo = mp_gmsh_types_info(elemType);
  nodesId = mp_gmsh_element_nodes(elemrec);
  nedges = length(elemInfo.edges);
  edges = cell(1, nedges);
  for i=1:nedges
    edges{i} = nodesId(elemInfo.edges{i});
  end
end