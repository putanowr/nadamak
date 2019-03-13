function [taggedEdges] = mp_get_tagged_region_edges(mesh, regionsSelector, taggingType)
%% return array of edge id and their tag
  if isa(taggingType, 'mp.Tagger')
    tagger = taggingType;
  else
    tagger = mp_get_tagger(taggingType);
  end
  
  prealloc_size = 100;
  teProxy = zeros(prealloc_size, 2, 'uint32');
  teCount = 0;
  v2e = mesh.getAdjacency(0, 1);
  for regionName = fieldnames(regionsSelector)'
    regions = mp_gmsh_regions_find(mesh.regions, struct('name', {regionName}));
    for r = regions 
      region = mesh.regions(r);
      elements = mp_gmsh_elems_find(mesh.elements, struct('region', region.id));
      for i=elements
        nodes = mp_gmsh_element_nodes(mesh.elements{i});
        et = mp_gmsh_element_type(mesh.elements{i});
        elemInfo = mp_gmsh_types_info(et);
        edgesDef = elemInfo.edges;
        nedges = length(edgesDef);
        for ei = 1:nedges
          edge = edgesDef{ei};
          edgeVerts = nodes(edge);
          edgeID = v2e.at(edgeVerts(1));
          for j=2:length(edgeVerts)
            edgeID = intersect(edgeID, v2e.at(edgeVerts(j)));
          end
          if (length(edgeID) ~= 1) 
            error('Internal error in matching 1D element of element edge to mesh edge')
          end
          te = find(ismember(teProxy(:,1), edgeID));
          if isempty(te)
            teCount = teCount + 1;
            teProxy(teCount, 1) = edgeID;
            teProxy(teCount, 2) = regionsSelector.(regionName{:});
            if teCount == length(teProxy)
              teProxy = [teProxy; zeros(prealloc_size, 2, 'uint32')];
            end   
          elseif length(te) == 1
            tg = regionsSelector.(regionName{:});
            teProxy(te, 2) = tagger.tag(teProxy(te, 2), tg); 
          else
            error('Internal error : the edge %d appears more than once in teProxy', n);
          end
        end
      end  
    end
  end
  taggedEdges = teProxy(1:teCount, 1:2);
end
