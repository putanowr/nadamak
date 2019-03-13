% Extract dimension from element record
function [dim] = mp_gmsh_element_dim(elrecord)
  eltype = elrecord(2);
  persistent elems_per_dim;
  if isempty(elems_per_dim)
    elems_per_dim = mp_gmsh_types_per_dim(); 
  end
  for i = 1:4
    if ismember(eltype, elems_per_dim{i})
      dim = i-1;
      return
    end
  end
  error('Could not fine element of type %d in elems_per_dim', eltype)
end
