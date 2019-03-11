%% Get elements acording to given selection criteria
% TODO: finish documentation
function [selectednodes] = mp_gmsh_elems_select_nodes(elements, regions, selector, prealloc_size)
  if nargin < 4
    prealloc_size = 100;
  end
  if isfield(selector, 'region')
    if iscellstr(selector.region)
      regionsId = mp_gmsh_regions_find_id(regions, struct('name', {selector.region}), 100);
    else
      regionsId = selector.region;
    end  
  end
  elemIds = mp_gmsh_elems_find(elements, struct('region', regionsId));
  selectednodes = mp_gmsh_nodes_from_elems(elements, elemIds, prealloc_size);
end
