function [pts] = mp_gmsh_edge_points(type, edgeId, numpts)
  % Return points on edge for reference element of given type.
  % TODO : finish documentation
  ti = mp_gmsh_types_info(type);
  edges = ti.edges;
  nodes = ti.nodes;
  en = edges{edgeId};
  n1 = en(1);
  n2 = en(end);
  pts = zeros(numpts, 3);
  pts(:,1) = linspace(nodes(n1,1), nodes(n2,1), numpts);
  pts(:,2) = linspace(nodes(n1,2), nodes(n2,2), numpts);
  pts(:,3) = linspace(nodes(n1,3), nodes(n2,3), numpts);
 end 
