%% Count how many regions fulfils given selection criteria.
% Selector is a structure with the following arrays
%   dim 
%   id
%   name 
% The same effect can be obtained with by calling
%   matching = mp_gmsh_regions_find(regions, selector)
%   counter = length(matchig);
% however this function doest it without storing the indices
% of regions matching selector.
%
function [counter] = mp_gmsh_regions_count(regions, selector)
  counter = 0;
  for i=1:length(regions)
    if mp_gmsh_region_matches(regions(i), selector)
      counter = counter+1;
    end
  end
end