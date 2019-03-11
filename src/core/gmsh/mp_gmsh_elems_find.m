%% Return vector of indices of records in elements array that match given selection criteria.
% TODO: finish documentation
function [matching] = mp_gmsh_elems_find(elements, selector, prealloc_size)
   if nargin < 3
    prealloc_size = 100;
  end
  matchproxy = zeros(1,prealloc_size,'int32');
  k = 0;
  for i=1:length(elements)
    if mp_gmsh_element_matches(elements{i}, selector)
      k=k+1;
      matchproxy(k) = i;
    end
    if k == length(matchproxy);
      matchproxy = [matchproxy, zeros(1,prealloc_size,'int32')];
    end
  end
  matching = matchproxy(1:k);
end