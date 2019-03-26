function coords = localCoordsHex8(dofID)
  % Normalized coordinates in reference element corresponding to DOF location.
  % If no dofID is given return the whole array of coordinates. 
  persistent crds
  persistent nn
  if isempty(crds)
    info = mp_gmsh_types_info('type_5');
    crds = info.nodes;
    nn = info.nnodes;
  end
  if nargin < 1 
    coords = crds;
  else
    r = rem(dofID-1,nn)+1;
    coords = crds(r, :);
  end
end
