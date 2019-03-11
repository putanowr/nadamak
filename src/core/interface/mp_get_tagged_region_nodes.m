function [taggedNodes] = mp_get_tagged_region_nodes(mesh, regionsSelector, taggingType)
%% return array node id and their tags
  if isa(taggingType, 'mp.Tagger')
    tagger = taggingType;
  else
    tagger = mp_get_tagger(taggingType);
  end
  
  prealloc_size = 100;
  tnProxy = zeros(prealloc_size, 2, 'int32');
  tnCount = 0;
  for regionName = fieldnames(regionsSelector)'
    regions = mp_gmsh_regions_find(mesh.regions, struct('name', {regionName}));
    for r = regions 
      region = mesh.regions(r);
      elements = mp_gmsh_elems_find(mesh.elements, struct('region', region.id));
      for i=elements
        for n = mp_gmsh_element_nodes(mesh.elements{i})
          tn = find(ismember(tnProxy(:,1), n));
          if isempty(tn)
            tnCount = tnCount + 1;
            tnProxy(tnCount, 1) = n;
            tnProxy(tnCount, 2) = regionsSelector.(regionName{:});
            if tnCount == length(tnProxy)
              tnProxy = [tnProxy; zeros(prealloc_size, 2, 'int32')];
            end   
          elseif length(tn) == 1
            tg = regionsSelector.(regionName{:});
            tnProxy(tn, 2) = tagger.tag(tnProxy(tn, 2), tg); 
          else
            error('Internal error : then node %d appears more than once in tnProxy', n);
          end
        end
      end  
    end
  end
  taggedNodes = tnProxy(1:tnCount, 1:2);
end
