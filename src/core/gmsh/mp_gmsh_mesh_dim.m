%% Finds the topological dimension of the mesh
%
% typetags - cell array of element typetags
function [dim] = mp_gmsh_mesh_dim(typetags)
  dim = -1;
  for tt = typetags
    tinfo = mp_gmsh_types_info(tt{1});
    if tinfo.dim > dim
      dim = tinfo.dim;
    end 
  end
end
