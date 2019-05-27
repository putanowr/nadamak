function [pts] = mp_gmsh_all_edges_points(type, numpts)
  % Return points on all edges edge for element of given type.
  % TODO : finish documentation
  ti = mp_gmsh_types_info(type);
  edges = ti.edges;
  nodes = ti.nodes;
  numEdges = numel(edges);
  npts = numEdges*numpts;
  pts = zeros(npts, 3);
  for i = 1:numEdges
    en = edges{i};  
    n1 = en(1);
    n2 = en(end);
    pi = (1:numpts)+(i-1)*numpts;
    pts(pi,1) = linspace(nodes(n1,1), nodes(n2,1), numpts);
    pts(pi,2) = linspace(nodes(n1,2), nodes(n2,2), numpts);
    pts(pi,3) = linspace(nodes(n1,3), nodes(n2,3), numpts);
 end 
