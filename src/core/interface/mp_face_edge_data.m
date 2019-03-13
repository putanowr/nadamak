function [elemEdges, elemTan, elemNor] = mp_face_edge_data(mesh)
  %% Calculate data for element edges
  % elemEdges [N, 4] array of integer tags (1 if edge is boundary one). 
  % elemTan   [N, 4, 2] array of doubles for tangent vectors
  % elemNor   [N, 4, 2] array of doubles for normal vectors
  % where N is number of faces in the mesh
  dim = mesh.dim;
  if dim ~= 2
    error('Function mp_edge_relations works correctly only for 2D mesh');
  end
  nfaces = mesh.facesCount();
  f2e = mesh.getAdjacency(2,1);
  e2f = mesh.getAdjacency(1,2);
  elemEdges = mp.SharedArray([nfaces, 4], 'int8');
  elemTan = zeros(nfaces, 4, 2);
  elemNor = zeros(nfaces, 4, 2);
  nedges = e2f.length;
  edgeVec = zeros(nedges, 3);
  e2v = mesh.getAdjacency(1,0);
  for i=1:nedges
    nodes = e2v.at(i);
    tv = mesh.nodes(nodes(2),:) - mesh.nodes(nodes(1),:);
    edgeVec(i,:) = tv/norm(tv);
  end
  for i=1:nfaces
    edges = f2e.at(i);
    ne = length(edges);
    for j=1:ne
      if length(e2f.at(edges(j))) == 1
        elemEdges(i,j) = 1;
      end
      ep = edgeVec(edges(j), 1:2);
      if mesh.faceEdgeOrient(i, j) < 0
        ep = -ep;
      end
      elemTan(i, j, :) = ep;
      elemNor(i, j, :) = [ep(2), -ep(1)];    
    end        
  end
end    
