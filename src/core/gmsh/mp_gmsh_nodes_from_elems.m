%% Get nodes IDs from specified elements
% TODO: finish documentation
function [selectednodes] = mp_gmsh_nodes_from_elems(elements, elemsIDs, prealloc_size)
  if nargin < 3
    prealloc_size = 500;
  end
  proxynodes = zeros(1, prealloc_size);
  k = 0;
  sl = length(proxynodes);
  for ie = elemsIDs
    nodes = mp_gmsh_element_nodes(elements{ie});
    nnodes = length(nodes);
    if sl - k < length(nodes)
      proxynodes = [proxynodes, zeros(1, prealloc_size)];
      sl = length(proxynodes);
    end
    proxynodes(k+1:k+nnodes) = nodes;
    k = k + nnodes;
  end  
  selectednodes = unique(proxynodes(1:k));
end
