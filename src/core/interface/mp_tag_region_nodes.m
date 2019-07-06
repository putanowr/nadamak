function [nodeTags] = mp_tag_region_nodes(mesh, regionsSelector, taggingType, defaultTag)
%% return array of node tags. The tags are assigned per region, by collecting nodes adjacent to
% elements in regions specified in regionsSelector. Nodes not affected by tagging process are
% assigned the default tag. If node belongs to more than one region the assigned tag is the
% calculated by mp.Tagger specified as taggingType. The argument 'taggingType' can be the string
% 'default', tagger type name or enum or a mp.Tagger object itself. 
%
% CAUTION: if taggingType='default' this function supports tag values in [0,1,2,3]
% with the following priorites (tag priority): (0,0), (1, 100), (2, 50), (3, 75)
  nodeTags = defaultTag*ones(mesh.countNodes(),1);
  if isa(taggingType, 'mp.Tagger')
    tagger = taggingType;
  else
    tagger = mp_get_tagger(taggingType);
  end
  for regionName = fieldnames(regionsSelector)'
    regions = mp_gmsh_regions_find(mesh.regions, struct('name', {regionName}));
    for r = regions 
      region = mesh.regions(r);
      elements = mp_gmsh_elems_find(mesh.elements, struct('region', region.id));
      for i=elements
        for n = mp_gmsh_element_nodes(mesh.elements{i});
          nodeTags(n) = tagger.tag(nodeTags(n), regionsSelector.(regionName{:}));
        end
      end  
    end
  end
end
