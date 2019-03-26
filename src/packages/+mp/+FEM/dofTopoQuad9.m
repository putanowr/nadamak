function dtopo = dofTopoQuad9(dofID)
  % returns vector [dim, id] where dim id dimension of the topological entity the DOF is located on
  % and id is the local entity number.
  % If no dofID is given return the array of [dim,id] for all DOFs. 
  % CAUTION: local edges and faces numbering corresponds to the one kept in mp_gmsh_types_info.
  persistent dofTopo 
  if isempty(dofTopo)
    dofTopo = [0, 1;
               0, 2;
               0, 3;
               0, 4;
               1, 1;
               1, 2;
               1, 3;
               1, 4;
               2, 1];
  end
  if nargin < 1 
    dtopo = dofTopo;
  else
    r = rem(dofID-1,size(dofTopo,1))+1;
    dtopo = dofTopo(r, :);
  end
end
