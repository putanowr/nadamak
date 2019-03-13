function dtopo = dofTopoLine2(dofID)
  % returns vector [dim, id] where dim id dimension of the topological entity the DOF is located on
  % and id is the local entity number.
  % If no dofID is given return the array of [dim,id] for all DOFs. 
  persistent dofTopo 
  if isempty(dofTopo)
    dofTopo = [0, 1;
               0, 2];
  end
  if nargin < 1 
    dtopo = dofTopo;
  else
    r = rem(dofID-1,2)+1;
    dtopo = dofTopo(r, :);
  end
end
