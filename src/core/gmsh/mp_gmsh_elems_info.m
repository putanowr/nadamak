%% Function to find global information about elements and return it as a structure 
%
function [ info ] = mp_gmsh_elems_info(elements)
  info = struct('nelems',0, 'dim', -1, 'ntypes', struct([]));
  if nargin < 1
    return
  else
    info.nelems = length(elements);
    for elrec = elements.Data
      typetag = mp_gmsh_element_typetag(elrec{:});
      if isfield(info.ntypes, typetag)
        info.ntypes.(typetag) = info.ntypes.(typetag)+1;
      else
        info.ntypes = struct(typetag, 1);
      end
    end
    info.dim = mp_gmsh_mesh_dim(fieldnames(info.ntypes));
  end   
end
