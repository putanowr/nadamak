%% Return vector of ids of regions matching given selection criteria.
% TODO: finish documentation
% CAUTION: do not confuse region ID with index of structure in regions
% array
function [ids] = mp_gmsh_regions_find_id(regions, selector, prealloc_size)
   if nargin < 3
     prealloc_size = 20;
   end
   matching = mp_gmsh_regions_find(regions, selector, prealloc_size);
   ids = arrayfun(@(x) ( x.id ), regions(matching), 'UniformOutput', true);
end