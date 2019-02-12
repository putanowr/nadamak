%% Get elements to nodes connectivity as a cell array.
%
function [connectivity] = mp_gmsh_elems_connectivity(elements)
  nelem = length(elements);
  connectivity = cell(nelem, 2);
  for i=1:nelem
    nnodes = mp_gmsh_node_count(elements{i}(2));
    connectivity{i, 1} = elements{i}(1);
    connectivity{i, 2} = elements{i}(end-nnodes+1:end);
  end
end