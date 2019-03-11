%% Get elements id acording to given selection criteria
% TODO: finish documentation
function [elemsubset] = mp_gmsh_elems_get(elements, selector, prealloc_size)
  if nargin < 3
    prealloc_size = 100;
  end
  
  matching = mp_gmsh_elems_find(elements, selector, prealloc_size);
  elemsubset = cell(length(matching), 1); % preallocate cell matrix for elements.
  i = 1;
  for id = matching
    elemsubset{i} = elements{id};
    i = i+1;
  end
end