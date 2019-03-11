%% Count how many elements fulfils given selectioncriteria.
% Selector is a structure with the following arrays
%   type 
%   region
%   geom 
% The same effect can be obtained with by calling
%   matching = mp_gmsh_elems_find(elements, selector)
%   counter = length(matchig);
% however this function doest it without storing the indices
% of elements matching selector.
%
function [counter] = mp_gmsh_elems_count(elements, selector)
  counter = 0;
  for i=1:length(elements)
    if mp_gmsh_element_matches(elements{i}, selector)
      counter = counter+1;
    end
  end
end