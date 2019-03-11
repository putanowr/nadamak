function [elemsEdges, elemsTan, elemsNor, nodesTan, nodesNor] = mp_face_edge_data_at_regions(mesh, selectEdgeTag, regionsSelector, taggingType)
  % This function tags all edges in region tags specified in regions selector.
  % Then it calculates table of edge tags for each element (elemEdges).
  % It calculates element normal and tangent vectors for each element side (elemTan and elemNor).
  % It calculates also normal and tangent vectors at nodes belonging to edges tagged with selectEdgeTag (nodesTan, nodesNor).
  [elemsEdges, elemsTan, elemsNor] = mp_face_edge_data(mesh);
  nnodes = mesh.nodesCount();
  nodesTan = mp.SharedArray([nnodes, 2], 'double');
  nodesNor = mp.SharedArray([nnodes, 2], 'double');
  f2e = mesh.getAdjacency(2, 1);
  e2v = mesh.getAdjacency(1, 0);
  e2f = mesh.getAdjacency(1, 2);
  taggedEdges = mp_get_tagged_region_edges(mesh, regionsSelector, taggingType);
  for i=1:size(taggedEdges, 1)
    edge = taggedEdges(i, 1);
    edgeTag = taggedEdges(i, 2);
    faces = e2f.at(edge);
    nodes = e2v.at(edge);
    for f = faces
      faceEdges = f2e.at(f);
      locEdge = find(faceEdges == edge);
      elemsEdges(f, locEdge) = edgeTag;
      if ismember(edgeTag,selectEdgeTag) 
        for n = nodes
          nodesTan(n, :) = nodesTan(n,:) + squeeze(elemsTan(f, locEdge, :))';
          nodesNor(n, :) = nodesNor(n,:) + squeeze(elemsNor(f, locEdge, :))';
        end
      end  
    end
  end
  for i=1:nnodes
    vtn = norm(nodesTan(i, :));
    if vtn > 1e-8
      vtn = 1/vtn;
      nodesTan(i, :) = nodesTan(i, :)*vtn;
    end
    vnn = norm(nodesNor(i, :));
    if vnn > 1e-8
      vnn = 1/vnn;
      nodesNor(i, :) = nodesNor(i, :)*vnn;
    end
  end
end    
