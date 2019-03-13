function [vertices] = mp_recover_face_from_edges(edges)
%mp_recover_face_from_edges
%   Given the eges-vertices adjacency recover the face-vertices adjacency
%   for the face bounded by the edges.
  n = size(edges, 1);
  vertices = zeros(1,n);
  k = 2; 
  vertices(1:2) = edges(1,:);
  edges(1,:) = 0;
  for e=2:n
    [i,j] = find(edges == vertices(k));
    if length(i) ~=1 || length(j) ~= 1
      error('The edges do not form clossed face');
    end
    j = 3-j;
    vertices(k+1) = edges(i,j);
    edges(i,:) = 0;
    k=k+1;
  end
  vertices = vertices(1:end-1);
end
