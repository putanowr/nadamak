%% Return vector of indices of structure in regions array that match given selection criteria.
% TODO: finish documentation
function [matching] = mp_gmsh_regions_find(regions, selector, prealloc_size)
   if nargin < 3
    prealloc_size = 100;
  end
  matchproxy = zeros(1,prealloc_size,'int32');
  k = 0;
  for i=1:length(regions)
    if mp_gmsh_region_matches(regions(i), selector)
      k=k+1;
      matchproxy(k) = i;
    end
    if k == length(matchproxy)
      matchproxy = [matchproxy, zeros(1,prealloc_size,'int32')];
    end
  end
  matching = matchproxy(1:k);
end